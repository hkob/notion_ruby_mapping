#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"embed","object":"block","embed":{"caption":[{"type":"text","text":{"content":"NotionRubyMapping開発記録(21)","link":null},"plain_text":"NotionRubyMapping開発記録(21)","href":null}],"url":"https://twitter.com/hkob/status/1507972453095833601"}}]}'
