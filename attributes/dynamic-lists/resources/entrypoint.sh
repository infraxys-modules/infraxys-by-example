#!/usr/bin/env sh

if [ -n "$@" ]; then # the user can insert additional elements in the list
  printf "$@
";
fi;

cat << EOF
value 1
value 2
EOF

