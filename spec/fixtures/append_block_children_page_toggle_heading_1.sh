#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_1","object":"block","heading_1":{"rich_text":[{"type":"text","text":{"content":"Toggle Heading 1","link":null},"plain_text":"Toggle Heading 1","href":null}],"color":"orange_background","is_toggleable":true,"children":[{"type":"bulleted_list_item","object":"block","bulleted_list_item":{"rich_text":[{"type":"text","text":{"content":"inside Toggle Heading 1","link":null},"plain_text":"inside Toggle Heading 1","href":null}],"color":"default"}}]}}]}'
