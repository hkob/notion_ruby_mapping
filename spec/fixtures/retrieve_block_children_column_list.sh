#!/bin/sh
curl  'https://api.notion.com/v1/blocks/93195eab21f74419bf440e4c07092573/children?page_size=100' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json'
