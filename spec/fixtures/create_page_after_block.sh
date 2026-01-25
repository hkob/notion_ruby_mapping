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
              "content": "New Page at after_block",
              "link": null
            },
            "plain_text": "New Page at after_block",
            "href": null
          }
        ]
      }
    },
    "position": {
      "type": "after_block",
      "after_block": {
        "id": "2f0d8e4e-98ab-812c-a8f5-cce62b2d3f6e"
      }
    }
  }'
