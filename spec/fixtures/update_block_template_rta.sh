#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/704d8961e0fd42c9b5b08a086c84f100' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"template":{"rich_text":[{"type":"text","text":{"content":"New template","link":null},"plain_text":"New template","href":null}]}}'
