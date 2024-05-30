-- File managed by Ansible.
{% for db in postgres_ha_databases %}

-- Create {{ db.name }} database.
CREATE USER "{{ db.get("user", db.name) }}" PASSWORD '{{ db.pass | mandatory }}';

CREATE DATABASE "{{ db.name }}"
WITH OWNER "{{ db.get("user", db.name) }}"
{% if 'locale' in db %}
LOCALE "{{ db.locale }}"
{% endif %}
{% if 'template' in db %}
TEMPLATE "{{ db.template }}"
{% endif %}
;
{% endfor %}
