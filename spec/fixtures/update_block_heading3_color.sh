#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/2bf3a507d066433fad10ed77b342664c' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_3":{"color":"green_background","rich_text":[{"type":"text","text":{"content":"Heading 3","link":null},"plain_text":"Heading 3","href":null}]}}'
