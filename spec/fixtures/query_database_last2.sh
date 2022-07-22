curl -X POST 'https://api.notion.com/v1/databases/c37a2c66e3aa4a0da44773de3b80c253/query' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Notion-Version: 2022-06-28' \
  -H "Content-Type: application/json" \
  --data '{
  "start_cursor": "986ebb25-e23f-4f05-99d6-2a531d8928c9",
  "page_size": 2
}'
