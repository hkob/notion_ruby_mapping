#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/ca7317b3b5d44a75880611264155dd48' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"pdf":{"external":{"url":"https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"}}}'
