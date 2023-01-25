#!/bin/sh
curl -X POST 'https://api.notion.com/v1/search' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"filter":{"value":"database","property":"object"},"query":"Sample table"}'