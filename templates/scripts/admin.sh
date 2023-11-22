#!/usr/bin/env bash
# vim: set ft=sh:
set -Eeo pipefail
export PGPASSWORD='{{ postgres_ha_admin_pass }}'
exec psql \
    --host='127.0.0.1' \
    --port='{{ postgres_ha_cont_port }}' \
    --username='{{ postgres_ha_admin_user }}' \
    --dbname='{{ postgres_ha_db_name }}' \
    "${@}"
