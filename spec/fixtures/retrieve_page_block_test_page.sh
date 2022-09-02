#!/bin/sh
curl  'https://api.notion.com/v1/pages/67cf059ce74646a0b72d481c9ff5d386' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json'
