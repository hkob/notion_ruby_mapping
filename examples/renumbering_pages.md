# Renumbering pages

The following code sets serial numbers to the pages whose title is not empty in ascending order of titles.

```Ruby
db = Database.new id: database_id, assign: [RichTextProperty, "TextTitle"]
tp = db.properties["TextTitle"]
query = tp.filter_is_not_empty.ascending(tp)
db.query_database(tp.filter_is_not_empty.ascending(tp)).each.with_index(1) do |page, index|
  page.properties["NumberTitle"].number = index
  page.save
end
```

| After execution                                  |
|--------------------------------------------------|
| ![After exuecution](../images/serial_number.png) |

---
[Return to README.md](../README.md)
