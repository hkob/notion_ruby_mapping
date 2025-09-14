#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8035a5b4ea240d930619/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_2","object":"block","heading_2":{"rich_text":[{"type":"text","text":{"content":"Heading 2","link":null},"plain_text":"Heading 2","href":null}],"color":"blue_background","is_toggleable":false}}]}'
