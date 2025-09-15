#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/26cd8e4e98ab8061b880f8f45db00383/children' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"column_list","object":"block","column_list":{"children":[{"type":"column","object":"block","column":{"children":[{"type":"callout","object":"block","callout":{"rich_text":[{"type":"text","text":{"content":"Emoji callout","link":null},"plain_text":"Emoji callout","href":null}],"color":"default","icon":{"type":"emoji","emoji":"✅"}}}]}},{"type":"column","object":"block","column":{"children":[{"type":"callout","object":"block","callout":{"rich_text":[{"type":"text","text":{"content":"Url callout","link":null},"plain_text":"Url callout","href":null}],"color":"default","icon":{"type":"external","external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"}}}}]}}]}}]}'
