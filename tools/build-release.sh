#!/bin/bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${DIST_DIR:-$ROOT_DIR/dist}"

VERSION="$(python3 - <<'PY' "$ROOT_DIR/acer_control/__init__.py"
import pathlib, re, sys
text = pathlib.Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r'^__version__\s*=\s*["\']([^"\']+)["\']', text, re.M)
if not m:
    raise SystemExit('cannot find __version__')
print(m.group(1))
PY
)"

INSTALL_VERSION="$(sed -n 's/^RELEASE_VERSION="\(.*\)"/\1/p' "$ROOT_DIR/install.sh" | head -1)"
[[ "$VERSION" == "$INSTALL_VERSION" ]] || {
    echo "Version mismatch: acer_control=$VERSION install.sh=$INSTALL_VERSION" >&2
    exit 1
}

NAME="acer-control-$VERSION"
WORK="$(mktemp -d -t acer-control-release.XXXXXXXX)"
trap 'rm -rf "$WORK"' EXIT
STAGE="$WORK/$NAME"
mkdir -p "$STAGE" "$DIST_DIR"

copy_path() {
    local rel="$1"
    cp -a "$ROOT_DIR/$rel" "$STAGE/$rel"
}

for rel in \
    README.md README.ru.md RELEASE-NOTES.md docs tools \
    acer_control assets defaults icons kernel packaging po tests \
    install.sh uninstall.sh; do
    copy_path "$rel"
done

find "$STAGE" -type d -name '__pycache__' -prune -exec rm -rf {} +
find "$STAGE" -type f -name '*.py[co]' -delete
find "$STAGE" -type f -name '*~' -delete

(
    cd "$STAGE"
    find . -type f ! -name MANIFEST.sha256 -print0 \
      | sort -z \
      | xargs -0 sha256sum > MANIFEST.sha256
)

TARBALL="$DIST_DIR/$NAME.tar.gz"
RUNFILE="$DIST_DIR/$NAME-installer.run"
SUMS="$DIST_DIR/$NAME.SHA256SUMS"

rm -f "$TARBALL" "$RUNFILE" "$SUMS"
tar -C "$WORK" -czf "$TARBALL" "$NAME"

cat > "$RUNFILE" <<STUB
#!/bin/bash
set -Eeuo pipefail

SELF="\$(readlink -f "\$0")"
MARKER='__ACER_CONTROL_ARCHIVE_BELOW__'
LINE="\$(awk -v marker="\$MARKER" '\$0 == marker { print NR + 1; exit }' "\$SELF")"
[[ -n "\$LINE" ]] || { echo "Installer payload marker not found" >&2; exit 1; }

if [[ "\${1:-}" == "--extract" ]]; then
    DEST="\${2:-./acer-control-installer-extracted}"
    mkdir -p "\$DEST"
    tail -n +"\$LINE" "\$SELF" | tar -xzf - -C "\$DEST"
    echo "Extracted to: \$DEST"
    exit 0
fi

TMP="\$(mktemp -d -t acer-control-installer.XXXXXXXX)"
cleanup() { rm -rf "\$TMP"; }
trap cleanup EXIT

tail -n +"\$LINE" "\$SELF" | tar -xzf - -C "\$TMP"
cd "\$TMP/$NAME"
./install.sh "\$@"
__ACER_CONTROL_ARCHIVE_BELOW__
STUB
cat "$TARBALL" >> "$RUNFILE"
chmod 0755 "$RUNFILE"

(
    cd "$DIST_DIR"
    sha256sum "$(basename "$TARBALL")" "$(basename "$RUNFILE")" > "$(basename "$SUMS")"
)

EXTRACT="$WORK/extracted"
"$RUNFILE" --extract "$EXTRACT" >/dev/null
cmp <(tar -tzf "$TARBALL" | sed 's#/$##' | sort) <(cd "$EXTRACT" && find "$NAME" -print | sed 's#^./##' | sort) >/dev/null || {
    echo "Self-extractor verification failed" >&2
    exit 1
}

printf 'Built:\n  %s\n  %s\n  %s\n' "$TARBALL" "$RUNFILE" "$SUMS"
