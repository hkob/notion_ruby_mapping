#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8061b880f8f45db00383/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"file","object":"block","file":{"type":"external","external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"},"caption":[{"type":"text","text":{"content":"macOS icon","link":null},"plain_text":"macOS icon","href":null}]}}]}'
