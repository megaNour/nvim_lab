#!/bin/sh

ENTRY=$(CDPATH='' cd -- "$(dirname "$0")" && pwd)

target=$HOME/.local/bin/lab
printf '%s\n' '#!/bin/sh' >"$target"
printf 'ENTRY=%s podman compose -f "%s" run --rm -it "$@" lab\n' "$ENTRY" "$ENTRY/compose.yaml" >>"$target"
chmod 744 "$target"
