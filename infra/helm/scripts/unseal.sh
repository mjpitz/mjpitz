#!/usr/bin/env bash

readonly key_path="${CERT:-./sealed-secrets/tls.key}"

for sealed_secret_file in $(find . -name 'sealed-secret-*.yaml'); do
  dir=$(dirname "${sealed_secret_file}")
  file=$(basename "${sealed_secret_file}")

  secret_file="$dir/${file#"sealed-"}"

  echo "unsealing '${sealed_secret_file}'"
  kubeseal --recovery-private-key "${key_path}" --recovery-unseal -o yaml < "${sealed_secret_file}" > "${secret_file}"
done
