#!/bin/sh
curl -X POST 'https://api.notion.com/v1/search' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"filter":{"value":"data_source","property":"object"},"query":"Sample table"}'
