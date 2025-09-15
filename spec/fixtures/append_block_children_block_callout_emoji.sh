#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8035a5b4ea240d930619/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"callout","object":"block","callout":{"rich_text":[{"type":"text","text":{"content":"Emoji callout","link":null},"plain_text":"Emoji callout","href":null}],"color":"blue","icon":{"type":"emoji","emoji":"✅"},"children":[{"type":"paragraph","object":"block","paragraph":{"rich_text":[{"type":"text","text":{"content":"with children","link":null},"plain_text":"with children","href":null}],"color":"default"}}]}}]}'
