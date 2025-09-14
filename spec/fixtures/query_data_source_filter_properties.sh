curl -X POST 'https://api.notion.com/v1/data_sources/4f93db514e1d4015b07f876e34c3b0b1/query?filter_properties=swq%5C&filter_properties=p%7Ci%3F' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Notion-Version: 2025-09-03' \
  -H "Content-Type: application/json"
