#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"to_do","object":"block","to_do":{"rich_text":[{"type":"text","text":{"content":"A sample To-Do","link":null},"plain_text":"A sample To-Do","href":null}],"checked":false,"color":"brown_background","children":[{"type":"paragraph","object":"block","paragraph":{"rich_text":[{"type":"text","text":{"content":"with children","link":null},"plain_text":"with children","href":null}],"color":"default"}}]}}]}'
