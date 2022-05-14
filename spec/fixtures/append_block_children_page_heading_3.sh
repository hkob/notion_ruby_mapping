#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_3","object":"block","heading_3":{"rich_text":[{"type":"text","text":{"content":"Heading 3","link":null},"plain_text":"Heading 3","href":null}],"color":"gray_background"}}]}'