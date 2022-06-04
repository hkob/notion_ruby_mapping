#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/930e8f09d7c24f5ebccdb5853bac5eb6' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"code":{"caption":[{"type":"text","text":{"content":"set an array","link":null},"plain_text":"set an array","href":null,"annotations":{"bold":false,"italic":false,"strikethrough":false,"underline":false,"code":false,"color":"default"}}]}}'