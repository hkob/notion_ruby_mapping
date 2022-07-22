#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/585aa9761ce143c2b9dba3e4503d78c2' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"image":{"caption":[{"type":"text","text":{"content":"macOS logo","link":null},"plain_text":"macOS logo","href":null}]}}'
