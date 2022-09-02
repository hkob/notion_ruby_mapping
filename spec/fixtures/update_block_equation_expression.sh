#!/bin/sh
curl -X PATCH 'https://api.notion.com/v1/blocks/db334fcf9f6d4f179edbe534229b1f87' \
  -H 'Notion-Version: 2022-06-28' \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H 'Content-Type: application/json' \
  --data '{"equation":{"expression":"X(z) = \\sum_{n=-\\infty}^{\\infty}x[n]z^{-n}"}}'
