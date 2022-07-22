#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/b3c6fe0a5885498aa5cb4c4b3080f4cf' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"table_of_contents":{"color":"orange_background"}}'