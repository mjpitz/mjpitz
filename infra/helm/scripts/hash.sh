#!/bin/sh
cat <<EOF
{
  "sha256": "$(git ls-files -s ${1:-.} | awk '{print $4}' | xargs -i{} bash -c 'echo "{}"; cat {}' | sha256sum | awk '{print $1}')"
}
EOF
