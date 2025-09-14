#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/930e8f09d7c24f5ebccdb5853bac5eb6' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"code":{"language":"ruby"}}'
