#!/usr/bin/env bash
# vim: set ft=sh:
set -Eeo pipefail

{% if not postgres_ha_replica_enabled %}
STATUS_QUERY='SELECT oid,datname,dattablespace FROM pg_catalog.pg_database WHERE datistemplate = false;'
HEALTH_REGEX='datname +| ({{ postgres_ha_databases | map(attribute="name") | join("|") }})'
{% elif postgres_ha_is_master %}
STATUS_QUERY='SELECT * FROM pg_stat_replication'
HEALTH_REGEX='status +| streaming'
{% else %}
STATUS_QUERY='SELECT * FROM pg_stat_wal_receiver'
HEALTH_REGEX='status +| streaming'
{% endif %}
REPLICA_STATUS=$(
    "{{ postgres_ha_service_path }}/admin.sh" -x -c "${STATUS_QUERY}"
)

if [[ ! "${REPLICA_STATUS}" =~ ${HEALTH_REGEX} ]]; then
    echo "ERROR: {{ postgres_ha_replica_enabled | ternary("Replication", "Tables") }} broken!"
    echo
    echo "${REPLICA_STATUS}";
    exit 2;
fi

echo "{{ postgres_ha_replica_enabled | ternary("Replication", "Tables") }} healthy."
echo
echo "${REPLICA_STATUS}" | grep -v -e '_lsn' -e '_lag'
