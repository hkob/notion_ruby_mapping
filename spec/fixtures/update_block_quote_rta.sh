#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/56e80c562281487281f4bf34d8db02bc' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"quote":{"rich_text":[{"type":"text","text":{"content":"new text","link":null},"plain_text":"new text","href":null}]}}'
