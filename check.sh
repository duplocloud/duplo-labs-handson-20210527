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

# Check if terraform is installed.
out "checking if terraform is installed"
if ! command -v terraform >/dev/null 2>&1; then
  die 'terraform is not installed!

  Please run ./setup.sh before proceeding.
'
fi

# Check if the right version of terraform is being used.
out "checking if terraform is version $tf_version"
if [ "$tf_version" != "$(terraform version 2>/dev/null | sed -ne 's@^Terraform v@@p')" ]; then
  die "terraform version is not ${tf_version}

  Please run ./setup.sh before proceeding.
"
fi

# Check if the duplo_host environment variable is set properly.
out "checking if duplo_host environment variable is set"
[ -n "$duplo_host" ] || die "duplo_host: environment variable not set

  Please setup your duplo_host and duplo_token environment variables.

"
duplo_hostname="${duplo_host#https://}"
[ "${duplo_hostname}" != "${duplo_host}" ] || die "duplo_host: must start with https://"
[ "${duplo_hostname#*/}" == "${duplo_hostname}" ] || die "duplo_host: must not end with a slash"

# Check if the duplo_token environment variable is set properly.
out "checking if duplo_token environment variable is set"
[ -n "$duplo_token" ] || die "duplo_token: environment variable not set

  Please setup your duplo_host and duplo_token environment variables.

"

# Check if the duplo_host and duplo_token are able to be used with a duplo API call.
out "checking if we can communicate with Duplo"
account_id="$(curl -Ssf -H 'Content-type: application/json' -H "Authorization: Bearer $duplo_token" "$@" "${duplo_host}/adminproxy/GetAwsAccountId" || true)"
[ -n "$account_id" ] || die "unable to communicate with duplo

  Please setup your duplo_host and duplo_token environment variables.

"

out 'complete

  You are ready to run the hands on lab!
'