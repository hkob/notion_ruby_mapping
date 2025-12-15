#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/2cad8e4e98ab806292f9cb56918b2c4c' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"audio":{"caption":[{"type":"text","text":{"content":"New caption","link":null},"plain_text":"New caption","href":null}]}}'

