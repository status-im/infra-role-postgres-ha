-- File managed by Ansible.
-- vim: ft=jinja2

-- Users
{% for user in (postgres_ha_users + postgres_ha_databases) %}
DO $$
BEGIN
    CREATE USER "{{ user.name | mandatory }}" PASSWORD '{{ user.pass | mandatory }}';
EXCEPTION WHEN duplicate_object THEN
    RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;
{% endfor %}

-- Databases
{% for db in postgres_ha_databases %}
CREATE DATABASE "{{ db.name }}" WITH OWNER "{{ db.get("user", db.name) }}"
{%- if 'locale' in db -%}
LOCALE "{{ db.locale }}"
{%- endif %}
{%- if 'template' in db -%}
TEMPLATE "{{ db.template }}"
{%- endif -%}
;
{% if 'script' in db %}
{{ db.script }}
{% endif %}
{% endfor %}

-- Permissions
{% for user in postgres_ha_users %}
\connect "{{ user.db | mandatory }}";
GRANT {{ user.priv | default("pg_read_all_data") }} ON DATABASE "{{ user.db | mandatory }}" TO "{{ user.name | mandatory }}";
GRANT {{ user.priv | default("pg_read_all_data") }} ON SCHEMA public TO "{{ user.name | mandatory }}";
{% endfor %}
-- Run additional init script
{{ postgres_ha_init_script }}
