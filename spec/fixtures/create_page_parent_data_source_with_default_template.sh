curl 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2025-09-03" \
  --data '{
    "parent": {
      "data_source_id": "293d8e4e98ab80e7842e000befaa8ed5"
    },
    "template": {
      "type": "default"
    },
    "properties": {
      "Name": {
        "type": "title",
        "title": [
          {
            "type": "text",
            "text": {
              "content": "New Page by data_source_id with default template",
              "link": null
            },
            "plain_text": "New Page by data_source_id with default template",
            "href": null
          }
        ]
      }
    }
  }'
