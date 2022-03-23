# Change title

The following code update the page title.

#### Pattern 1 (replace existing text partially)

```Ruby
page = Page.find page_id # API access
print page.title # -> ABC\nDEF
tp = page.properties["Title"]
tp[1].text = "GHI"
page.save # API access
print page.title # -> ABC\nGHI
```

#### Pattern 2 (replace all text)

```Ruby
page = Page.new id: page_id, assign: [TitleProperty, "Title"]
tp = page.properties["Title"]
tp << TextObject.new("JKL")
page.save # API access
print page.title # -> JKL
```
---
[Return to README.md](../README.md#2-example-code)