-- File managed by Ansible.
-- vim: ft=jinja2

-- Users
{% for user in (postgres_ha_users + postgres_ha_databases) %}
CREATE USER "{{ user.name | mandatory }}" PASSWORD '{{ user.pass | mandatory }}';
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
GRANT {{ user.priv | default("pg_read_all_data") }} ON DATABASE {{ user.db | mandatory }} TO {{ user.name | mandatory }};
{% endfor %}
