#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"bookmark","object":"block","bookmark":{"caption":[{"type":"text","text":{"content":"Google","link":null},"plain_text":"Google","href":null}],"url":"https://www.google.com"}}]}'
