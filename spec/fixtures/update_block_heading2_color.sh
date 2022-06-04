#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/a7873498c1cc4032bc4e975b80ec1a1b' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_2":{"color":"green_background","rich_text":[{"type":"text","text":{"content":"Heading 2","link":null},"plain_text":"Heading 2","href":null}]}}'
