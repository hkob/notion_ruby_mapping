curl https://api.notion.com/v1/pages/20bd8e4e98ab80c79576dcf6f6e5ee4a \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -X PATCH \
	--data '{
	  "icon": {
		  "type": "file_upload",
		  "file_upload": {
			  "id": "20cd8e4e-98ab-81aa-973b-00b23083c115"
		  }
	  }
}'
