#!/bin/sh
curl  'https://api.notion.com/v1/blocks/29a966bb81eb43e5aae1b44992525775/children?page_size=100' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json'
