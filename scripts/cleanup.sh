#!/bin/sh

API_URL="https://api.hosting.ionos.com/dns/v1"
API_KEY_HEADER="X-API-Key: $API_KEY"

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN ]; then
    ZONE_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN)
    rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN

    RECORD_NAME="_acme-challenge.$CERTBOT_DOMAIN"
    RECORD_GET_RESPONSE=$(curl -s -X GET "$API_URL/zones/$ZONE_ID?recordName=$RECORD_NAME&recordType=TXT" -H "$API_KEY_HEADER" -H "Accept: application/json")
    RECORD_IDS=$(echo $RECORD_GET_RESPONSE | jq -r '.records[] | select(.name=="'"$RECORD_NAME"'") | .id')
fi

if [ -n "$ZONE_ID" -a -n "$RECORD_IDS" ]; then
    echo "$RECORD_IDS" \
    | xargs -n1 -I {} curl -s -X DELETE "$API_URL/zones/$ZONE_ID/records/{}" \
            -H "$API_KEY_HEADER"
fi
