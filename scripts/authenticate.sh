#!/bin/sh

API_URL="https://api.hosting.ionos.com/dns/v1"
API_KEY_HEADER="X-API-Key: $API_KEY"

ZONE_RESPONSE=$(curl -s -X GET "$API_URL/zones" -H "$API_KEY_HEADER" -H "Accept: application/json")
ZONE_ID=$(echo $ZONE_RESPONSE | jq -r '.[] | select(.name=="'"$CERTBOT_DOMAIN"'") | .id')

RECORD_NAME="_acme-challenge.$CERTBOT_DOMAIN"
RECORD_CREATE_RESPONSE=$(curl -s -X POST "$API_URL/zones/$ZONE_ID/records" -H "$API_KEY_HEADER" -H "Content-Type: application/json" --data '[{"name": "'"$RECORD_NAME"'", "type": "TXT", "content": "'"$CERTBOT_VALIDATION"'", "ttl": 3600, "prio": 100, "disabled": false}]')

echo $ZONE_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN

sleep 10