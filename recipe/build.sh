#!/usr/bin/env bash
set -euo pipefail

# build `enable` first (required by chaco)
# --no-build-isolation tells `pip` to trust the `conda` environment's tools
# [layout,svg] extras are required for chaco
cd $SRC_DIR/enable
"$PYTHON" -m pip install .[layout,svg] --no-build-isolation --no-deps --ignore-installed -v --prefix="$PREFIX"

# verify `enable`
if [[ ! -f "$SP_DIR/enable/__init__.py" ]]; then
    echo "ERROR: enable/__init__.py not found in $SP_DIR" >&2
    exit 1
fi

# build `chaco`
cd $SRC_DIR/chaco
"$PYTHON" -m pip install . --no-build-isolation --no-deps --ignore-installed -v --prefix="$PREFIX"

# verify `chaco`
if [[ ! -f "$SP_DIR/chaco/__init__.py" ]]; then
    echo "ERROR: chaco/__init__.py not found in $SP_DIR" >&2
    exit 1
fi
