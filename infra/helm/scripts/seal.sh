#!/usr/bin/env bash

readonly cert_path="${CERT:-./sealed-secrets/tls.crt}"

for secret_file in $(find . -name 'secret-*.yaml'); do
  # make sure the file is only accessible to you
  chmod 600 "${secret_file}"

  sealed_secret_file="$(dirname "${secret_file}")/sealed-$(basename "${secret_file}")"

  echo "sealing '${secret_file}'"
  kubeseal --cert "${cert_path}" --scope namespace-wide -o yaml < "${secret_file}" > "${sealed_secret_file}"
done
