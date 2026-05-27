#!/usr/bin/env bash
set -euo pipefail

# Export SDK path and compiler flags for pip subprocesses (macOS)
if [[ "$(uname)" == "Darwin" ]]; then
    # Use configured sysroot if it exists, otherwise fall back to system SDK
    if [[ -n "${CONDA_BUILD_SYSROOT:-}" && -d "${CONDA_BUILD_SYSROOT}" ]]; then
        export SDKROOT="${CONDA_BUILD_SYSROOT}"
    else
        export SDKROOT="$(xcrun --show-sdk-path)"
    fi
    export CFLAGS="${CFLAGS:-} -isysroot ${SDKROOT}"
    export CXXFLAGS="${CXXFLAGS:-} -isysroot ${SDKROOT} -Wno-register"
fi

# `enable`
cd $SRC_DIR/enable

# * --no-build-isolation tells `pip` to trust the `conda` environment's tools
# * [layout,svg] extras are required for chaco
"$PYTHON" -m pip install .[layout,svg] --no-build-isolation --no-deps --ignore-installed -v --prefix="$PREFIX"

# verify `enable` installed correctly
if [[ ! -f "$SP_DIR/enable/__init__.py" ]]; then
    echo "ERROR: enable/__init__.py not found in $SP_DIR" >&2
    exit 1
fi

# `chaco`
cd $SRC_DIR/chaco

"$PYTHON" -m pip install . --no-build-isolation --no-deps --ignore-installed -v --prefix="$PREFIX"

# verify `chaco` installed correctly
if [[ ! -f "$SP_DIR/chaco/__init__.py" ]]; then
    echo "ERROR: enable/__init__.py not found in $SP_DIR" >&2
    exit 1
fi
