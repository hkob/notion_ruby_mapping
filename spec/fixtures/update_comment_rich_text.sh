curl -X PATCH 'https://api.notion.com/v1/comments/37921658084045ae924ad9ce1d60375b' \
  -H 'Notion-Version: 2026-03-11' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{
    "rich_text": [
      {
        "type": "text",
        "text": {
          "content": "update comment by rich text",
          "link": null
        },
        "plain_text": "update comment by rich text",
        "href": null
      }
    ]
  }'
