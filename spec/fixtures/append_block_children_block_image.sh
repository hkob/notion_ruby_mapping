#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"image","object":"block","image":{"type":"external","external":{"url":"https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"},"caption":[{"type":"text","text":{"content":"Notion logo","link":null},"plain_text":"Notion logo","href":null}]}}]}'