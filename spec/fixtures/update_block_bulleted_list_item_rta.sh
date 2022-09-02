#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/ab51d1c7094649b5b9007ef0109b33c4' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"bulleted_list_item":{"rich_text":[{"type":"text","text":{"content":"new text","link":null},"plain_text":"new text","href":null}]}}'
