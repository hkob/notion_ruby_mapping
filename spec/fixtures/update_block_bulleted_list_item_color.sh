#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/ab51d1c7094649b5b9007ef0109b33c4' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"bulleted_list_item":{"color":"orange_background","rich_text":[{"type":"text","text":{"content":"old text","link":null},"plain_text":"old text","href":null,"annotations":{"bold":false,"italic":false,"strikethrough":false,"underline":false,"code":false,"color":"default"}}]}}'
