#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"callout","object":"block","callout":{"rich_text":[{"type":"text","text":{"content":"Url callout","link":null},"plain_text":"Url callout","href":null}],"color":"default","icon":{"type":"external","external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"}},"children":[{"type":"paragraph","object":"block","paragraph":{"rich_text":[{"type":"text","text":{"content":"with children","link":null},"plain_text":"with children","href":null}],"color":"default"}}]}}]}'