#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/00ce5fe04b5b485ba157914ae048b780' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_2":{"rich_text":[{"type":"text","text":{"content":"New Heading 2","link":null},"plain_text":"New Heading 2","href":null}]}}'
