#!/bin/sh
curl -X DELETE 'https://api.notion.com/v1/blocks/a1949aaefbfa46f3bd1a90687b86bf1a' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''
