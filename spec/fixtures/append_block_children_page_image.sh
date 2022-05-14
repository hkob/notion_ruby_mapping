#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"image","object":"block","image":{"type":"external","external":{"url":"https://cdn.worldvectorlogo.com/logos/notion-logo-1.svg"},"caption":[{"type":"text","text":{"content":"Notion logo","link":null},"plain_text":"Notion logo","href":null}]}}]}'