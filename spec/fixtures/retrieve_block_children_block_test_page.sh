#!/bin/sh
curl  'https://api.notion.com/v1/blocks/67cf059ce74646a0b72d481c9ff5d386/children?page_size=100' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json'
