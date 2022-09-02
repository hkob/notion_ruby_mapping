#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"pdf","object":"block","pdf":{"type":"external","external":{"url":"https://github.com/onocom/sample-files-for-demo-use/raw/151dd797d54d7e0ae0dc50e8e19d7965b387e202/sample-pdf.pdf"}}}]}'
