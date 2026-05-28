#!/usr/bin/env bash
set -euo pipefail

# build `chaco`
# --no-build-isolation tells `pip` to trust the `conda` environment's tools
cd $SRC_DIR/chaco
"$PYTHON" -m pip install . --no-build-isolation --no-deps --ignore-installed -v --prefix="$PREFIX"

# verify `chaco`
if [[ ! -f "$SP_DIR/chaco/__init__.py" ]]; then
    echo "ERROR: chaco/__init__.py not found in $SP_DIR" >&2
    exit 1
fi
