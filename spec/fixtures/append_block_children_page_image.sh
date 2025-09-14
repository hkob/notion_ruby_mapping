#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8061b880f8f45db00383/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"image","object":"block","image":{"type":"external","external":{"url":"https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"},"caption":[{"type":"text","text":{"content":"Notion logo","link":null},"plain_text":"Notion logo","href":null}]}}]}'
