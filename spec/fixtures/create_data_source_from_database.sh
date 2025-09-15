curl -X POST 'https://api.notion.com/v1/data_sources/' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  -H 'accept: application/json' \
  -H 'Notion-Version: 2025-09-03' \
  --data '{
    "parent": {
        "type": "database_id",
        "database_id": "c37a2c66e3aa4a0da44773de3b80c253"
    },
    "icon": {
        "type": "emoji",
        "emoji": "🎉"
    },
    "title":[{"type":"text","text":{"content":"New data source title","link":null},"plain_text":"New data source title","href":null}],
    "properties":{"Checkbox":{"checkbox":{}},"CreatedBy":{"created_by":{}},"CreatedTime":{"created_time":{}},"Date":{"date":{}},"Email":{"email":{}},"Files":{"files":{}},"Formula":{"formula":{"expression":"now()"}},"LastEditedBy":{"last_edited_by":{}},"LastEditedTime":{"last_edited_time":{}},"MultiSelect":{"multi_select":{"options":[{"name":"MS1","color":"orange"},{"name":"MS2","color":"green"}]}},"Number":{"number":{"format":"yen"}},"People":{"people":{}},"PhoneNumber":{"phone_number":{}},"Relation":{"relation":{"data_source_id":"4f93db514e1d4015b07f876e34c3b0b1","type":"single_property","single_property":{}}},"Rollup":{"rollup":{"function":"sum","relation_property_name":"Relation","rollup_property_name":"NumberTitle"}},"RichText":{"rich_text":{}},"Select":{"select":{"options":[{"name":"S1","color":"yellow"},{"name":"S2","color":"default"}]}},"Title":{"title":{}},"Url":{"url":{}}}}'
