curl https://api.notion.com/v1/pages/c01166c613ae45cbb96818b4ef2f5a77 \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2025-09-03" \
  -X PATCH \
  --data '{
    "icon": {
      "type": "external",
      "external": {
        "url": "https://cdn.profile-image.st-hatena.com/users/hkob/profile.png"
      }
    }
  }'
