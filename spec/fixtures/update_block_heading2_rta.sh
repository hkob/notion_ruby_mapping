#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/a7873498c1cc4032bc4e975b80ec1a1b' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_2":{"rich_text":[{"type":"text","text":{"content":"New Heading 2","link":null},"plain_text":"New Heading 2","href":null}]}}'