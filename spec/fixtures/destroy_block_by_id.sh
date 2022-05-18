#!/bin/sh
curl -X DELETE 'https://api.notion.com/v1/blocks/7306e4c4bc5b48d78948e59ec0059afd' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''
