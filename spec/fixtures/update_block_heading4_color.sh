#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/32ad8e4e98ab804c9173c15694f45c5f' \
  -H 'Notion-Version: 2026-03-11' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_4":{"color":"green_background","rich_text":[{"type":"text","text":{"content":"Heading 4","link":null},"plain_text":"Heading 4","href":null}]}}'

