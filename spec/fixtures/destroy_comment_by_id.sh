#!/bin/sh
curl -X DELETE 'https://api.notion.com/v1/comments/37921658084045ae924ad9ce1d60375b' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"''
