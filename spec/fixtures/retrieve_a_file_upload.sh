curl --request GET \
     --url https://api.notion.com/v1/file_uploads/21fd8e4e-98ab-8108-bb77-00b2ea9e9905 \
     -H 'accept: application/json' \
     -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
     -H 'Notion-Version: 2022-06-28'
