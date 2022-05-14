#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"code","object":"block","code":{"rich_text":[{"type":"text","text":{"content":"% ls -l","link":null},"plain_text":"% ls -l","href":null}],"caption":[{"type":"text","text":{"content":"List files","link":null},"plain_text":"List files","href":null}],"language":"shell"}}]}'