#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"link_to_page","object":"block","link_to_page":{"type":"page_id","page_id":"c01166c613ae45cbb96818b4ef2f5a77"}}]}'