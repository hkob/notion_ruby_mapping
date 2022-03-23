curl --location --request PATCH 'https://api.notion.com/v1/databases/c7697137d49f49c2bbcdd6a665c4f921' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-02-22' \
  --data '{"properties": {"renamed number property": null, "renamed url property": null}}'