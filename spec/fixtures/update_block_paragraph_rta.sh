#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/7de3e4c08c5f4082992268d154f9aefc' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"paragraph":{"rich_text":[{"type":"text","text":{"content":"new paragraph text","link":null},"plain_text":"new paragraph text","href":null}]}}'