#!/bin/sh
cat <<EOF
{
  "sha256": "$(find ${1:-.} -type f | xargs -I{} bash -c 'echo "{}"; cat {}' | sha256sum | awk '{print $1}')"
}
EOF
