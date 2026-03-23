curl 'https://api.notion.com/v1/pages/315d8e4e98ab8108901dcfa2d3993f6e/markdown' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -X PATCH \
  --data '{
    "type": "replace_content_range",
    "replace_content_range": {
      "content": "1. Replace numbered item",
      "content_range": "- [x] To Do",
      "allow_deleting_content": true
    }
  }'
