#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/da9929d35cd849d7990e2ee361239810' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"numbered_list_item":{"rich_text":[{"type":"text","text":{"content":"new text","link":null},"plain_text":"new text","href":null}]}}'