#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"heading_2","object":"block","heading_2":{"rich_text":[{"type":"text","text":{"content":"Heading 2","link":null},"plain_text":"Heading 2","href":null}],"color":"blue_background"}}]}'