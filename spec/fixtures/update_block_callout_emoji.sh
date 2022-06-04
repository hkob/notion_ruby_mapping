#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/05386a91dfa24296b6b2ac4676006bdb' \
  -H 'Notion-Version: 2022-02-22' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"callout":{"icon":{"type":"emoji","emoji":"💡"}}}'