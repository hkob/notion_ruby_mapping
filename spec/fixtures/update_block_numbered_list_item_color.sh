#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/da9929d35cd849d7990e2ee361239810' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"numbered_list_item":{"color":"orange_background","rich_text":[{"type":"text","text":{"content":"old text","link":null},"plain_text":"old text","href":null}]}}'