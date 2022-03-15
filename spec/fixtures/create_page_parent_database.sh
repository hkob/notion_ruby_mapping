curl 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-02-22" \
  --data '{
    "parent": {
      "database_id": "1d6b1040a9fb48d99a3d041429816e9f"
    },
    "properties": {
      "Name": {
        "type": "title",
        "title": [
          {
            "type": "text",
            "text": {
              "content": "New Page Title",
              "link": null
            },
            "plain_text": "New Page Title",
            "href": null
          }
        ]
      }
    }
  }'
