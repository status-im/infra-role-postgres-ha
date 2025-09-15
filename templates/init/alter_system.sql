-- File managed by Ansible.
{% for key,val in postgres_ha_alter_system_settings.items() %}
ALTER SYSTEM SET {{ key }} = '{{ val }}';
{% endfor %}
{% if postgres_ha_perf_metrics_exporter_enabled %}
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
CREATE extension pg_stat_statements;
{% endif %}
