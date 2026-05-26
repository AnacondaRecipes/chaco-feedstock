#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
# `enable`
# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
cd $SRC_DIR/enable

# * --no-build-isolation tells `pip` to trust the `conda` environment's tools
# * [layout,svg] extras are required for chaco
"${PYTHON}" -m pip install .[layout,svg] --no-build-isolation --no-deps --ignore-installed -v --prefix="${PREFIX}"
echo "Files installed"
"${PYTHON}" -c "import site; print(site.getsitepackages())"
"${PYTHON}" -c "import enable; from pathlib import Path; print(Path(enable.__file__).resolve())"
ls "${SP_DIR}/enable" 2>/dev/null || echo "NOT in SP_DIR"

# verify `enable` installed correctly
if [[ ! -f "${SP_DIR}/enable/__init__.py" ]]; then
    echo "ERROR: enable/__init__.py not found in ${SP_DIR}" >&2
    exit 1
fi

# ensure `enable` can be imported correctly
"${PYTHON}" -c "import enable; print('enable installed okay')"

# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
# `chaco`
# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
cd $SRC_DIR/chaco
"${PYTHON}" -m pip install . --no-build-isolation --no-deps --ignore-installed -v --prefix="${PREFIX}"
echo "Files installed"
"${PYTHON}" -c "import site; print(site.getsitepackages())"
"${PYTHON}" -c "import chaco; from pathlib import Path; print(Path(chaco.__file__).resolve())"
ls "${SP_DIR}/chaco" 2>/dev/null || echo "NOT in SP_DIR"

# verify `chaco` installed correctly
if [[ ! -f "${SP_DIR}/chaco/__init__.py" ]]; then
    echo "ERROR: enable/__init__.py not found in ${SP_DIR}" >&2
    exit 1
fi

# ensure `chaco` can be imported correctly
"${PYTHON}" -c "import chaco; print('chaco installed okay')"
