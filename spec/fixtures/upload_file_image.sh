curl --request POST \
  --url 'https://api.notion.com/v1/file_uploads/20cd8e4e-98ab-81aa-973b-00b23083c115/send' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Content-Type: multipart/form-data' \
  -F "file=@ErSxuLeq.png-medium.png"
