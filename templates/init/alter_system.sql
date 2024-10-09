-- File managed by Ansible.
{% for key,val in postgres_ha_alter_system_settings.items() %}
ALTER SYSTEM SET {{ key }} = '{{ val }}';
{% endfor %}
{% if not postgres_ha_perf_metrics_exporter_disabled %}
CREATE extension pg_stat_statements;
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
{% endif %}
