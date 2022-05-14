#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/3867910a437340be931cf7f2c06443c6/children' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"synced_block","object":"block","synced_block":{"synced_from":null,"children":[{"type":"bulleted_list_item","object":"block","bulleted_list_item":{"rich_text":[{"type":"text","text":{"content":"Synced block","link":null},"plain_text":"Synced block","href":null}],"color":"default"}},{"type":"divider","object":"block","divider":{}}]}}]}'