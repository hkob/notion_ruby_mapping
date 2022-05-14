#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"column_list","object":"block","column_list":{"children":[{"type":"column","object":"block","column":{"children":[{"type":"callout","object":"block","callout":{"rich_text":[{"type":"text","text":{"content":"Emoji callout","link":null},"plain_text":"Emoji callout","href":null}],"color":"default","icon":{"type":"emoji","emoji":"✅"}}}]}},{"type":"column","object":"block","column":{"children":[{"type":"callout","object":"block","callout":{"rich_text":[{"type":"text","text":{"content":"Url callout","link":null},"plain_text":"Url callout","href":null}],"color":"default","icon":{"type":"external","external":{"url":"https://img.icons8.com/ios-filled/250/000000/mac-os.png"}}}}]}}]}}]}'