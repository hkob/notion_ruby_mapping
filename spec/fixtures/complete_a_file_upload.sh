curl --request POST \
    --url https://api.notion.com/v1/file_uploads/21ad8e4e-98ab-814e-8d96-00b2ded97d6c/complete \
    -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
    -H 'Content-Type: application/json' \
    -H 'Notion-Version: 2022-06-28'
