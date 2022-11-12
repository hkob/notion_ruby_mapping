#!/bin/sh
curl "https://api.notion.com/v1/users?page_size=100" \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''
