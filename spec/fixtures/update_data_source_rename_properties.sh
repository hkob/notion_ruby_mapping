curl --location --request PATCH 'https://api.notion.com/v1/data_sources/26cd8e4e98ab81d08983000b28d9e04d' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2025-09-03' \
  --data '{"properties":{"added number property":{"name":"renamed number property"}, "added url property":{"name":"renamed url property"}}}'
