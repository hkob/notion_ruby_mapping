#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab807da59ad04ce5219bf3' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"bookmark":{"caption":[{"type":"text","text":{"content":"Apple","link":null},"plain_text":"Apple","href":null}]}}'
