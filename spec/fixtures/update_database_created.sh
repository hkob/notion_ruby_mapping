curl --location --request PATCH 'https://api.notion.com/v1/databases/c7697137d49f49c2bbcdd6a665c4f921' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H 'Notion-Version: 2022-06-28' \
  --data '{"properties":{"Select":{"select":{"options":[{"id":"56a526e1-0cec-4b85-b9db-fc68d00e50c6","name":"S1","color":"yellow"},{"id":"6ead7aee-d7f0-40ba-aa5e-59bccf6c50c8","name":"S2","color":"default"},{"name":"S3","color":"red"}]}},"Rollup":{"rollup":{"function":"average","relation_property_name":"Relation","rollup_property_name":"NumberTitle"}},"Relation":{"relation":{"database_id":"c37a2c66e3aa4a0da44773de3b80c253","dual_property":{"synced_property_name":"Renamed table","synced_property_id":"mfBo"}}},"Number":{"number":{"format":"percent"}},"MultiSelect":{"multi_select":{"options":[{"id":"98aaa1c0-4634-47e2-bfae-d739a8c5e564","name":"MS1","color":"orange"},{"id":"71756a93-cfd8-4675-b508-facb1c31af2c","name":"MS2","color":"green"},{"name":"MS3","color":"blue"}]}},"Formula":{"formula":{"expression":"pi"}}},"title":[{"type":"text","text":{"content":"New database title","link":null},"plain_text":"New database title","href":null,"annotations":{"bold":false,"italic":false,"strikethrough":false,"underline":false,"code":false,"color":"default"}},{"type":"text","text":{"content":"(Added)","link":null},"plain_text":"(Added)","href":null}],"icon":{"type":"emoji","emoji":"🎉"}}'
