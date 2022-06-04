#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/7ba68fa8f57f456cbd7c73fa37f7f3ea' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"embed":{"caption":[{"type":"text","text":{"content":"NotionRubyMapping v0.4.0","link":null},"plain_text":"NotionRubyMapping v0.4.0","href":null}]}}'
