#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8061b880f8f45db00383/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"link_to_page","object":"block","link_to_page":{"type":"page_id","page_id":"c01166c613ae45cbb96818b4ef2f5a77"}}]}'
