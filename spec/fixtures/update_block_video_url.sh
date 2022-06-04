#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/8c49d0d66f9b45fb9bea6253997c87ba' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"video":{"external":{"url":"https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"}}}'