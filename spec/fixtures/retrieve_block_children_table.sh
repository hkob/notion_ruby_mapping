#!/bin/sh
curl  'https://api.notion.com/v1/blocks/ba612e8bc85845699822ccca7ab4c709/children?page_size=100' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json'
