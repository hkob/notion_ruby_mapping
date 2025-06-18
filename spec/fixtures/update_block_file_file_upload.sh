#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/20bd8e4e98ab8081ad29dd62726e4525' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{
      "file": {
        "file_upload":{
          "id": "20cd8e4e-98ab-81aa-973b-00b23083c115"
        }
      }
  }'

