#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8035a5b4ea240d930619/children' \
  -H 'Notion-Version: 2026-03-11' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_4","object":"block","heading_4":{"rich_text":[{"type":"text","text":{"content":"Toggle Heading 4","link":null},"plain_text":"Toggle Heading 4","href":null}],"color":"yellow_background","is_toggleable":true,"children":[{"type":"bulleted_list_item","object":"block","bulleted_list_item":{"rich_text":[{"type":"text","text":{"content":"inside Toggle Heading 4","link":null},"plain_text":"inside Toggle Heading 4","href":null}],"color":"default"}}]}}]}'
