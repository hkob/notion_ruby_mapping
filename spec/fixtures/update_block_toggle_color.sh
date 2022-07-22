#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/5b7373a8ac82456684a02e761aabf6fc' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"toggle":{"color":"orange_background","rich_text":[{"type":"text","text":{"content":"Old To Do","link":null},"plain_text":"Old To Do","href":null}]}}'