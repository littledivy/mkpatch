#!/usr/bin/env bash
set -e

commit=$(git rev-parse HEAD)
patchfile="patch-${commit}.patch"
applyscript="apply-${commit}.sh"

git format-patch -1 "$commit" -o . --stdout > "$patchfile"

cat > "$applyscript" <<EOF
#!/usr/bin/env bash
# This script applies the patch for commit $commit

set -e
patchfile="$patchfile"

if [ ! -f "\$patchfile" ]; then
  echo "Error: Patch file '\$patchfile' not found."
  exit 1
fi

echo "Applying patch \$patchfile..."
git apply "\$patchfile"
echo "Patch applied successfully!"
EOF

chmod +x "$applyscript"

echo "Created:"
echo "  - $patchfile"
echo "  - $applyscript"
