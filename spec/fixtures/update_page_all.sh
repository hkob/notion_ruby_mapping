curl https://api.notion.com/v1/pages/206ffaa277744a99baf593e28730240c \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-02-22" \
  -X PATCH \
  --data '{
  "properties": {
    "CheckboxTitle": {
      "checkbox": true,
      "type": "checkbox"
    },
    "DateTitle": {
      "type": "date",
      "date": {
        "start": "2022-03-14",
        "end": null,
        "time_zone": null
      }
    },
    "MailTitle": {
      "email": "hkobhkob@gmail.com",
      "type": "email"
    },
    "File&MediaTitle": {
      "files": [
        {
          "name": "https://img.icons8.com/ios-filled/250/000000/mac-os.png",
          "type": "external",
          "external": {
            "url": "https://img.icons8.com/ios-filled/250/000000/mac-os.png"
          }
        }
      ],
      "type": "files"
    },
    "MultiSelectTitle": {
      "type": "multi_select",
      "multi_select": [
        {
          "name": "Multi Select 2"
        }
      ]
    },
    "UserTitle": {
      "type": "people",
      "people": [
        {
          "object": "user",
          "id": "2200a911-6a96-44bb-bd38-6bfb1e01b9f6"
        }
      ]
    },
    "RelationTitle": {
      "type": "relation",
      "relation": [
        {
          "id": "860753bb6d1f48de96211fa6e0e31f82"
        }
      ]
    },
    "NumberTitle": {
      "number": 3.1415926535,
      "type": "number"
    },
    "TelTitle": {
      "phone_number": "zz-zzzz-zzzz",
      "type": "phone_number"
    },
    "SelectTitle": {
      "type": "select",
      "select": {
        "name": "Select 3"
      }
    },
    "TextTitle": {
      "type": "rich_text",
      "rich_text": [
        {
          "type": "text",
          "text": {
            "content": "new text",
            "link": null
          },
          "plain_text": "new text",
          "href": null
        }
      ]
    },
    "Title": {
      "type": "title",
      "title": [
        {
          "type": "text",
          "text": {
            "content": "MNO",
            "link": null
          },
          "plain_text": "MNO",
          "href": null
        }
      ]
    },
    "UrlTitle": {
      "url": "https://www.google.com/",
      "type": "url"
    }
  }
}'
