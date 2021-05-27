#!/bin/bash -eu

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tf_version="0.14.11"

# Utility function for outputing a message.
out() {
  echo "$0:" "$@"
}

# Utility function for outputing an error.
err() {
  echo "$0:" "$@" 1>&2
}

# Utility function for a fatal error.
die() {
  err "$@"
  exit 1
}

# OS detection
sys="$(uname -s)"
case "$sys" in
Darwin)
  sys="darwin"
  ;;
Linux)
  sys="linux"
  ;;
*)
  die "$sys: unsupported operating system"
esac

# CPU detection
arch="$(uname -m)"
case "$arch" in
x86)
  arch=386
  ;;
x86_64)
  arch=amd64
  ;;
armv[8-9]*|armv1[0-9]*)
  arch=arm64
  ;;
arm*)
  arch=arm
  ;;
*)
  die "$arch: unsupported cpu architecture"
;;
esac

# Terraform download and installation
tf_tmp="$project_root/tmp"
tf_bin="$project_root/bin"
out "./bin/terraform: downloading for $sys $arch"
rm -rf "$tf_tmp" || true
trap 'out "cleaning up temporary files" ; rm -rf $tf_tmp' EXIT

mkdir -p "$tf_tmp"
tf_download="https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_${sys}_${arch}.zip"
curl -Sslfo "$tf_tmp/terraform.zip" "$tf_download"

out "./bin/terraform: installing"
rm -f "$tf_bin/terraform"
unzip -q -d "$tf_bin" "$tf_tmp/terraform.zip" terraform
chmod +x "$tf_bin/terraform"
