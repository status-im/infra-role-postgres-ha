-- File managed by Ansible.
{% for db in postgres_ha_databases %}

-- Create {{ db.name }} database.
CREATE USER "{{ db.get("user", db.name) }}" PASSWORD '{{ db.pass | mandatory }}';
CREATE DATABASE "{{ db.name }}" WITH OWNER "{{ db.get("user", db.name) }}";
{% endfor %}
