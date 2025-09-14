#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/20bd8e4e98ab80269cd7e7c36a2072a0' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{
      "video": {
        "file_upload":{
          "id": "21ad8e4e98ab814e8d9600b2ded97d6c"
        }
      }
  }'
