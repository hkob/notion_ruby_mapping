#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8035a5b4ea240d930619/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"table_of_contents","object":"block","table_of_contents":{"color":"pink"}}]}'
