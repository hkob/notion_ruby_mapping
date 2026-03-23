#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/03f6460c26734af484b95de15082d84e/children' \
  -H 'Notion-Version: 2026-03-11' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"numbered_list_item","object":"block","numbered_list_item":{"rich_text":[{"type":"text","text":{"content":"start block","link":null},"plain_text":"start block","href":null}],"color":"default"}}], "position": {"type": "start"}}'
