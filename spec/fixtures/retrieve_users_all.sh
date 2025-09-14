#!/bin/sh
curl "https://api.notion.com/v1/users?page_size=100" \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''
