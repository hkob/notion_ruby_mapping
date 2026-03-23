curl 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2025-09-03" \
  --data '{
    "parent": {
      "data_source_id": "f0a1bf337ff04d24b5b6efb3ea006b15"
    },
    "markdown": "# New page with markdown\n## Paragraph 2\n- [ ] To Do\n- [x] Checked To Do\n"
  }'
