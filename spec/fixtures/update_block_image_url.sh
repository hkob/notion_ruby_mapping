#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/9e78e7714adf4055b78b3a1528b956d6' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"image":{"external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"}}}'