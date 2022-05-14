#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_1","object":"block","heading_1":{"rich_text":[{"type":"text","text":{"content":"Heading 1","link":null},"plain_text":"Heading 1","href":null}],"color":"orange_background"}}]}'