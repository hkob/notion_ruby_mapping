curl 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2025-09-03" \
  --data '{
    "parent": {
      "type": "page_id",
      "page_id": "2f0d8e4e98ab8065b3a2ec9fd4b3e57a"
    },
    "properties": {
      "title": {
        "type": "title",
        "title": [
          {
            "type": "text",
            "text": {
              "content": "New Page at page_start",
              "link": null
            },
            "plain_text": "New Page at page_start",
            "href": null
          }
        ]
      }
    },
    "position": {
      "type": "page_start"
    }
  }'
