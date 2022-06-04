#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/683ef29efbb84d78a411c541d68ccb06' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"to_do":{"rich_text":[{"type":"text","text":{"content":"new To Do","link":null},"plain_text":"new To Do","href":null}]}}'