#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/8c49d0d66f9b45fb9bea6253997c87ba' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"video":{"caption":[{"type":"text","text":{"content":"New caption","link":null},"plain_text":"New caption","href":null}]}}'
