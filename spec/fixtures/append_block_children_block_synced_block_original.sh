#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8035a5b4ea240d930619/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"synced_block","object":"block","synced_block":{"synced_from":null,"children":[{"type":"bulleted_list_item","object":"block","bulleted_list_item":{"rich_text":[{"type":"text","text":{"content":"Synced block","link":null},"plain_text":"Synced block","href":null}],"color":"default"}},{"type":"divider","object":"block","divider":{}}]}}]}'
