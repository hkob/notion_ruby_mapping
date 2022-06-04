#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/bed94c76d41849599143d345ef48a11e' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"file":{"external":{"url":"https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"}}}'