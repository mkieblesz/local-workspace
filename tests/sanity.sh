#!/bin/bash

check_url_response_status() {
    URL=$1
    REQ_STATUS_CODE=${2:-200}

    STATUS_CODE=$(curl -s -o /dev/null -w ''%{http_code}'' $URL)
    if [ $STATUS_CODE = $REQ_STATUS_CODE ]; then
        echo "[OK] $URL"
    else
        echo "[ERROR] $URL $STATUS_CODE != $REQ_STATUS_CODE"
    fi
}

check_url_response_status "api.trade.great:8000/admin/login/?next=/admin/" 200
check_url_response_status "buyer.trade.great:8001/find-a-buyer/" 200
check_url_response_status "opportunities.export.great:8002" 200
check_url_response_status "sso.trade.great:8003/admin/" 401
check_url_response_status "sso-proxy.trade.great:8004/sso/admin/login/?next=/sso/admin/" 200
check_url_response_status "supplier.trade.great:8005/trade/" 200
check_url_response_status "profile.trade.great:8006/profile/about/" 200
check_url_response_status "exred.trade.great:8007" 200
check_url_response_status "soo.trade.great:8008/selling-online-overseas/" 200
check_url_response_status "cms.trade.great:8010/admin/login/?next=/admin/" 200
check_url_response_status "forms.trade.great:8011/admin/login/?next=/admin/" 200
check_url_response_status "invest.trade.great:8012" 200
check_url_response_status "international.trade.great:8013/international/" 200
