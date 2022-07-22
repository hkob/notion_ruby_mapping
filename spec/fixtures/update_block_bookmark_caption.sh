#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/899e342cec84415f9ff86225704cbb75' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"bookmark":{"caption":[{"type":"text","text":{"content":"Apple","link":null},"plain_text":"Apple","href":null}]}}'