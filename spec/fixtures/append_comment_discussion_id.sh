curl -X POST 'https://api.notion.com/v1/comments' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"rich_text":[{"type":"text","text":{"content":"test comment to discussion","link":null},"plain_text":"test comment to discussion","href":null}],"discussion_id":"4475361640994a5f97c653eb758e7a9d"}'
