curl --request POST \
  --url 'https://api.notion.com/v1/file_uploads/21ad8e4e-98ab-814e-8d96-00b2ded97d6c/send' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Notion-Version: 2025-09-03' \
  -H 'Content-Type: multipart/form-data' \
  -F "file=@/var/folders/cw/9fjhttb17jbb3233xc3k9l3c0000gp/T/split20250622-98904-sy5cs0" \
  -F "part_number=1"
