curl -X POST 'https://api.notion.com/v1/data_sources/4f93db514e1d4015b07f876e34c3b0b1/query' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Notion-Version: 2025-09-03' \
  -H "Content-Type: application/json" \
	--data '{
    "page_size": 2
    }'
