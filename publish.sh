#!/bin/bash
# Publishes the Moventra privacy and support pages to GitHub Pages.
set -e
export PATH="$HOME/.local/bin:$PATH"
cd "$(dirname "$0")"
echo "Privacy policy and support pages for the Moventra iPhone app." > README.md
[ -d .git ] || git init -q -b main
git add -A
git -c user.name="Joseph Huntley" -c user.email=joseph.huntley@gmail.com commit -q -m "Moventra privacy and support pages"
gh repo create jhunt2323/moventra-info --public --description "Privacy policy and support pages for the Moventra iPhone app" --source . --push
gh api -X POST repos/jhunt2323/moventra-info/pages -f 'source[branch]=main' -f 'source[path]=/' > /dev/null
echo "Waiting for the pages to go live..."
for i in $(seq 1 30); do
  if [ "$(curl -s -o /dev/null -w '%{http_code}' https://jhunt2323.github.io/moventra-info/privacy.html)" = 200 ]; then
    echo "DONE: https://jhunt2323.github.io/moventra-info/privacy.html"; exit 0
  fi
  sleep 10
done
echo "Published, but the page isn't showing yet. Give it a few minutes."
