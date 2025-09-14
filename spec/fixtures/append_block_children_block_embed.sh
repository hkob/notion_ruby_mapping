#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8035a5b4ea240d930619/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"embed","object":"block","embed":{"caption":[{"type":"text","text":{"content":"NotionRubyMapping開発記録(21)","link":null},"plain_text":"NotionRubyMapping開発記録(21)","href":null}],"url":"https://twitter.com/hkob/status/1507972453095833601"}}]}'
