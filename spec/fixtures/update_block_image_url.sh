#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/585aa9761ce143c2b9dba3e4503d78c2' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"image":{"external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"}}}'
