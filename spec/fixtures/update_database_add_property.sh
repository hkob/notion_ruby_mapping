curl --location --request PATCH 'https://api.notion.com/v1/databases/c7697137d49f49c2bbcdd6a665c4f921' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  --data '{"properties": {"added number property": {"number": {"format": "euro"}}, "added url property": {"url": {}}}}'