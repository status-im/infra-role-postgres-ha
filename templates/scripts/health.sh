#!/usr/bin/env bash
# vim: set ft=sh:
set -Eeo pipefail

{% if postgres_ha_is_master %}
STATUS_QUERY='SELECT * FROM pg_stat_replication'
{% else %}
STATUS_QUERY='SELECT * FROM pg_stat_wal_receiver'
{% endif %}
REPLICA_STATUS=$(
    "{{ postgres_ha_service_path }}/admin.sh" -x -c "${STATUS_QUERY}"
)

function fail() {
    echo "ERROR: Replication broken!"
    echo
    echo "${REPLICA_STATUS}";
    exit 2;
}

{% if postgres_ha_is_master %}
REGEX='state +| streaming'
{% else %}
REGEX='status +| streaming'
{% endif %}
[[ ! "${REPLICA_STATUS}" =~ ${REGEX} ]] && fail

echo "Replication healthy."
echo
echo "${REPLICA_STATUS}" | grep -v -e '_lsn' -e '_lag'
