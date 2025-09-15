#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8061b880f8f45db00383/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"synced_block","object":"block","synced_block":{"synced_from":{"type":"block_id","block_id":"4815032e-6f24-43e4-bc8c-9bdc6299b090"}}}]}'
