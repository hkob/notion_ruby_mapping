#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/0ae3399d5599419e84af80433e1290b4' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_1":{"rich_text":[{"type":"text","text":{"content":"New Heading 1","link":null},"plain_text":"New Heading 1","href":null}]}}'
