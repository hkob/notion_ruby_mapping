#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/e16aa38d136e4fcaa54c3a18f6140350' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_3":{"rich_text":[{"type":"text","text":{"content":"New Heading 3","link":null},"plain_text":"New Heading 3","href":null}]}}'