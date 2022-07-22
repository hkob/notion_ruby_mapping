#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/ca7317b3b5d44a75880611264155dd48' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"pdf":{"caption":[{"type":"text","text":{"content":"new caption","link":null},"plain_text":"new caption","href":null}]}}'