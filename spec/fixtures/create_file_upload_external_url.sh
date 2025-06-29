curl --request POST \
  --url 'https://api.notion.com/v1/file_uploads' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H  'Notion-Version: 2022-06-28' \
  --data '{
    "mode": "external_url",
    "external_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
    "filename": "dummy.pdf"
  }'
