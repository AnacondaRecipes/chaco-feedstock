#!/usr/bin/env bash
set -euo pipefail

# # macOS-specific compiler flags
# if [[ "$(uname)" == "Darwin" ]]; then
#     # Suppress C++17 'register' warnings from bundled AGG/freetype code
#     export CXXFLAGS="${CXXFLAGS:-} -Wno-register"
#
#     # Disable legacy Carbon/ATS APIs removed in macOS 15+ SDK
#     macos_version=$(sw_vers -productVersion | cut -d. -f1)
#     if [[ "$macos_version" -ge 15 ]]; then
#         # -DDARWIN_NO_CARBON: disable removed Carbon/ATS APIs
#         # -DByte='unsigned char': fix missing Byte typedef in bundled freetype2 zlib
#         export CFLAGS="${CFLAGS:-} -DDARWIN_NO_CARBON '-DByte=unsigned char'"
#     fi
# fi

# build `enable`
# --no-build-isolation tells `pip` to trust the `conda` environment's tools
# [layout,svg] extras are required for chaco
cd $SRC_DIR/enable
"$PYTHON" -m pip install .[layout,svg] --no-build-isolation --no-deps --ignore-installed -v --prefix="$PREFIX"

# verify `enable`
if [[ ! -f "$SP_DIR/enable/__init__.py" ]]; then
    echo "ERROR: enable/__init__.py not found in $SP_DIR" >&2
    exit 1
fi
