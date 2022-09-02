#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_3","object":"block","heading_3":{"rich_text":[{"type":"text","text":{"content":"Toggle Heading 3","link":null},"plain_text":"Toggle Heading 3","href":null}],"color":"gray_background","is_toggleable":true,"children":[{"type":"bulleted_list_item","object":"block","bulleted_list_item":{"rich_text":[{"type":"text","text":{"content":"inside Toggle Heading 3","link":null},"plain_text":"inside Toggle Heading 3","href":null}],"color":"default"}}]}}]}'
