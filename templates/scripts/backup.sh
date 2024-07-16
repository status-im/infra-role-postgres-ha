#!/usr/bin/env bash
# vim: ft=sh
set -e
BKP_DIR="{{ postgres_ha_cont_backup_vol }}"
DATABASES=(
  "{{ postgres_ha_db_name }}"
{% for db in postgres_ha_databases %}
  "{{ db.get("name", db.user) }}"
{% endfor %}
)
for DB in "${DATABASES[@]}"; do
  DB_DUMP_DIR="${BKP_DIR}/${DB}"
  echo "pg_dump: ${DB} > ${DB_DUMP_DIR}"
  [[ -d "${DB_DUMP_DIR}" ]] && rm -r "${DB_DUMP_DIR}"
  docker exec -i {{ postgres_ha_cont_name }} \
    pg_dump \
      -F directory \
      -f "/backup/${DB}" \
      -U {{ postgres_ha_admin_user }} \
      "${DB}"
done
chown dockremap:dockremap -R "${BKP_DIR}"/*
chmod 750 -R "${BKP_DIR}"
