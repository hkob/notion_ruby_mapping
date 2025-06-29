#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/20bd8e4e98ab80e6ad4cdfd71964c48c' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"pdf":{"type":"file_upload", "file_upload":{"id": "21fd8e4e98ab8108bb7700b2ea9e9905"}}}'


