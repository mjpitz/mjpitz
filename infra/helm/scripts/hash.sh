#!/bin/sh
cat <<EOF
{
  "sha256": "$(find ${1:-.} -type f | xargs cat | sha256sum | awk '{print $1}')"
}
EOF
