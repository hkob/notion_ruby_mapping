#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/a9b7ff827c5b41dba01374b1af8fb516' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"heading_1":{"rich_text":[{"type":"text","text":{"content":"New Heading 1","link":null},"plain_text":"New Heading 1","href":null}]}}'
