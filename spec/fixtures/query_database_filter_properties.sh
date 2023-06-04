curl -X POST 'https://api.notion.com/v1/databases/c37a2c66e3aa4a0da44773de3b80c253/query?filter_properties=swq%5C&filter_properties=p%7Ci%3F' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Notion-Version: 2022-06-28' \
  -H "Content-Type: application/json"
