-- File managed by Ansible.
{% for key,val in postgres_alter_system_settings.items() %}
ALTER SYSTEM SET {{ key }} = '{{ val }}';
{% endfor %}
