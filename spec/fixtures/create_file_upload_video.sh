#!/bin/sh
curl --request POST \
  --url 'https://api.notion.com/v1/file_uploads' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  --data '{
    "mode": "multi_part",
    "number_of_parts": 2,
    "filename": "sample-15s.mp4"
  }'
