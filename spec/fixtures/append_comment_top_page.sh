curl -X POST 'https://api.notion.com/v1/comments' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"rich_text":[{"type":"text","text":{"content":"test comment","link":null},"plain_text":"test comment","href":null}],"parent":{"page_id":"c01166c613ae45cbb96818b4ef2f5a77"}}'
