#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/03f6460c26734af484b95de15082d84e/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"numbered_list_item","object":"block","numbered_list_item":{"rich_text":[{"type":"text","text":{"content":"Middle block","link":null},"plain_text":"Middle block","href":null}],"color":"default"}}], "after": "263f125b179e4e4f996a1eff812d9d3d"}'
