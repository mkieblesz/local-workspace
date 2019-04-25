#!/bin/bash

GLOBAL_MAX_RETRIES=${1:-0}

check_url_response_status() {
    URL=$1
    REQ_STATUS_CODE=${2:-200}
    MAX_RETRIES=${MAX_RETRIES:-$GLOBAL_MAX_RETRIES}

    RETRIES=0
	until false; do
        STATUS_CODE=$(curl -s -o /dev/null -w ''%{http_code}'' $URL)

        if [ $STATUS_CODE = $REQ_STATUS_CODE ]; then
            echo "[OK] $URL"
        else
            ERROR_MSG="[ERROR] $URL $STATUS_CODE != $REQ_STATUS_CODE"
            if [ $MAX_RETRIES = "-1" ] || [ $RETRIES != $MAX_RETRIES ]; then
                RETRIES=$((1 + $RETRIES))
                sleep 1

                BOLD=$'\033[1m'
                RESETALL=$'\033[0m'
                echo "$ERROR_MSG ${BOLD}(Retrying...)${RESETALL}"
                continue
            fi
            echo $ERROR_MSG
        fi
        break
    done
}

check_url_response_status "api.trade.great:8000/admin/login/?next=/admin/"
check_url_response_status "buyer.trade.great:8001/find-a-buyer/"
check_url_response_status "opportunities.trade.great:8002/export-opportunities"
check_url_response_status "sso.trade.great:8003/admin/" 401
check_url_response_status "sso-proxy.trade.great:8004/sso/admin/login/?next=/sso/admin/"
check_url_response_status "supplier.trade.great:8005/trade/"
check_url_response_status "profile.trade.great:8006/profile/about/"
check_url_response_status "exred.trade.great:8007"
check_url_response_status "soo.trade.great:8008/selling-online-overseas/"
check_url_response_status "cms.trade.great:8010/admin/login/?next=/admin/"
check_url_response_status "forms.trade.great:8011/admin/login/?next=/admin/"
check_url_response_status "invest.trade.great:8012"
check_url_response_status "international.trade.great:8013/international/"
