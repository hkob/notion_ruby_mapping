#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/32ad8e4e98ab808998eae6b408766d68' \
  -H 'Notion-Version: 2026-03-11' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_4":{"rich_text":[{"type":"text","text":{"content":"New Toggle Heading 4","link":null},"plain_text":"New Toggle Heading 4","href":null}]}}'
