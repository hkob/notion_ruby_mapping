#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/82314687163e41baaf300a8a2bec57c2/children' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"children":[{"type":"table","object":"block","table":{"has_column_header":true,"has_row_header":true,"table_width":2,"children":[{"type":"table_row","object":"block","table_row":{"cells":[[{"type":"text","text":{"content":"Services","link":null},"plain_text":"Services","href":null}],[{"type":"text","text":{"content":"Account","link":null},"plain_text":"Account","href":null}]]}},{"type":"table_row","object":"block","table_row":{"cells":[[{"type":"text","text":{"content":"Twitter","link":null},"plain_text":"Twitter","href":null}],[{"type":"text","text":{"content":"hkob\n","link":null},"plain_text":"hkob\n","href":null},{"type":"text","text":{"content":"profile","link":{"url":"https://twitter.com/hkob/"}},"plain_text":"profile","href":"https://twitter.com/hkob/"}]]}},{"type":"table_row","object":"block","table_row":{"cells":[[{"type":"text","text":{"content":"GitHub","link":null},"plain_text":"GitHub","href":null}],[{"type":"text","text":{"content":"hkob\n","link":null},"plain_text":"hkob\n","href":null},{"type":"text","text":{"content":"repositories","link":{"url":"https://github.com/hkob/"}},"plain_text":"repositories","href":"https://github.com/hkob/"}]]}}]}}]}'