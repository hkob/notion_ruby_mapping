#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/0ae3399d5599419e84af80433e1290b4' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_1":{"color":"green_background","rich_text":[{"type":"text","text":{"content":"Heading 1","link":null},"plain_text":"Heading 1","href":null,"annotations":{"bold":false,"italic":false,"strikethrough":false,"underline":false,"code":false,"color":"default"}}]}}'
