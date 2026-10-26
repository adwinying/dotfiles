#!/usr/bin/env bash
# Builds ScreenZen's Firefox add-on for Helium (Chromium), which ScreenZen doesn't support natively.
# The add-on only talks to the ScreenZen app over a local WebSocket, so it just needs Firefox's
# promise-based `browser.*` calls mapped onto Chromium's callback APIs.
# Load the output dir via chrome://extensions > Developer mode > Load unpacked, in each profile.
set -euo pipefail

out=${1:-$HOME/.local/share/screenzen-helium}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -fsSL "https://addons.mozilla.org/firefox/downloads/latest/screenzen-blocker/latest.xpi" -o "$tmp/addon.xpi"
unzip -q "$tmp/addon.xpi" -d "$tmp/addon" -x '__MACOSX/*' 'META-INF/*'

cat > "$tmp/addon/chromium-shim.js" <<'EOF'
const promisify = (fn) => (...args) =>
  new Promise((resolve, reject) =>
    fn(...args, (result) => (chrome.runtime.lastError ? reject(chrome.runtime.lastError) : resolve(result))));

globalThis.browser = {
  runtime: chrome.runtime,
  tabs: {
    onUpdated: chrome.tabs.onUpdated,
    onActivated: chrome.tabs.onActivated,
    get: promisify(chrome.tabs.get),
    update: promisify(chrome.tabs.update),
  },
};
EOF

jq '.background.scripts |= ["chromium-shim.js"] + . | del(.browser_specific_settings)' \
  "$tmp/addon/manifest.json" > "$tmp/manifest.json"
mv "$tmp/manifest.json" "$tmp/addon/manifest.json"

rm -rf "$out"
mkdir -p "$(dirname "$out")"
mv "$tmp/addon" "$out"
echo "built $(jq -r .version "$out/manifest.json") -> $out"
