#!/usr/bin/env bash
set -euo pipefail

commit=$(git rev-parse HEAD)
outfile="apply-${commit}.sh"

{
  echo "#!/usr/bin/env bash"
  echo "# Self-applying patch for commit $commit"
  echo "set -euo pipefail"
  echo "tmp=\$(mktemp)"
  echo "trap 'rm -f \$tmp' EXIT"
  echo "awk '/^__PATCH_BELOW__/ {found=1; next} found {print}' \"\$0\" >\"\$tmp\""
  echo "echo '→ Applying patch from $commit'"
  echo "git apply \"\$tmp\""
  echo "exit \$?"
  echo "__PATCH_BELOW__"
  git format-patch -1 "$commit" --stdout
} > "$outfile"

chmod +x "$outfile"
echo "Created self-applying patch script: $outfile"
