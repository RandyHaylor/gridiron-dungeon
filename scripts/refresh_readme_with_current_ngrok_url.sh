#!/bin/bash
# Updates README.md with the currently-active ngrok public URL and pushes
# JUST THAT FILE to origin/main. Never stages anything else.
#
# Reads ngrok URL from the local ngrok agent's web inspector at :4040.
# Designed to be safe to run repeatedly (cron-friendly): if the URL hasn't
# changed, it does nothing.
#
# Usage:
#   bash scripts/refresh_readme_with_current_ngrok_url.sh
#
# Optional cron entry (every 5 minutes):
#   */5 * * * * cd /home/aikenyon/ai_skills_agents_resources/source-of-truth-test-1 && bash scripts/refresh_readme_with_current_ngrok_url.sh >> /tmp/refresh_readme_ngrok.log 2>&1

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

# 1. Get the current ngrok https URL (or bail if no tunnel is up)
CURRENT_NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels \
  | python3 -c "import sys,json
try:
    d=json.load(sys.stdin)
    ts=d.get('tunnels',[])
    print(next((t['public_url'] for t in ts if t['public_url'].startswith('https://')), ''))
except Exception:
    print('')" || true)

if [ -z "$CURRENT_NGROK_URL" ]; then
  echo "[refresh-readme] No active ngrok tunnel on :4040 — skipping."
  exit 0
fi

# 2. Pull existing URL from README.md (the only line starting with **https://...ngrok)
EXISTING_NGROK_URL=$(grep -oE 'https://[^*[:space:]]+\.ngrok-free\.app' README.md | head -1 || true)

if [ "$CURRENT_NGROK_URL" = "$EXISTING_NGROK_URL" ]; then
  echo "[refresh-readme] URL unchanged ($CURRENT_NGROK_URL) — no commit."
  exit 0
fi

echo "[refresh-readme] Updating README.md: $EXISTING_NGROK_URL -> $CURRENT_NGROK_URL"

# 3. Replace the URL in-place. Use python so we don't have to escape sed special chars.
python3 - <<PYEOF
import re, sys
p = "README.md"
old = open(p).read()
new = re.sub(r"https://[^*\s]+\.ngrok-free\.app", "$CURRENT_NGROK_URL", old)
if new != old:
    open(p,"w").write(new)
PYEOF

# 4. Commit and push ONLY README.md.
git add README.md
git diff --cached --quiet && { echo "[refresh-readme] No staged changes after edit — bailing."; exit 0; }
git commit -q -m "Refresh README with current ngrok URL ($CURRENT_NGROK_URL)"
git push -q origin main
echo "[refresh-readme] Pushed."
