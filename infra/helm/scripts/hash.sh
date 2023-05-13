#!/bin/sh
cat <<EOF
{
  "sha256": "$(git ls-files ${1:-.} | xargs -i{} bash -c 'echo "{}"; cat {}' | sha256sum | awk '{print $1}')"
}
EOF
