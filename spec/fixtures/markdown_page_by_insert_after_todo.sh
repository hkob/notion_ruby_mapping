curl 'https://api.notion.com/v1/pages/315d8e4e98ab8108901dcfa2d3993f6e/markdown' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -X PATCH \
  --data '{
    "type": "insert_content",
    "insert_content": {
      "content": "1. Added numbered item after To Do item\n",
      "after": "- [ ] To Do\n"
    }
  }'
