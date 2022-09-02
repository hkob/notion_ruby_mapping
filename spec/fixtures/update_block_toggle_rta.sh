#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/5b7373a8ac82456684a02e761aabf6fc' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"toggle":{"rich_text":[{"type":"text","text":{"content":"New Toggle","link":null},"plain_text":"New Toggle","href":null}]}}'
