#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/05386a91dfa24296b6b2ac4676006bdb' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"callout":{"icon":{"type":"external","external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"}}}}'
