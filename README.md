# Description

This role configures a High-Availability [PostgreSQL](https://www.postgresql.org/) Database with replication from master to slaves.

# Configuration

To run just one instance without actual High-Availability use:
```yaml
postgres_ha_db_name: 'example-db'
postgres_ha_admin_user: 'admin'
postgres_ha_admin_pass: 'super-secret-password'
```
For replicaton other settings
```yaml
postgres_ha_is_master: '{{ hostname == "node-01.example.org" }}'
postgres_ha_replica_host: 'node-01.example.org'
postgres_ha_replica_port: 5043
postgres_ha_replica_allowed_addresses: ['11.12.13.15']
```
You can create additional databases using:
```yaml
# Databases to init
postgres_ha_databases:
  - name: my-db
    user: my-user
    pass: my-pass
    script: 'CREATE SCHEMA IF NOT EXIST example;'

  - name: my-other-db
    user: my-other-user
    pass: my-other-pass
```
The `user` field is optional. DB name is used by default.
The field `script` is optional and allow to add commands to run when creating the database.

Additional users can be defined using:
```yaml
postgres_ha_users:
  - name: 'devops'
    pass: 'hunter2'
    db:   'my-db'
    priv: 'ALL PRIVILEGES'

  - name: 'security'
    pass: 'hunter3'
    db:   'my-db'
    priv: 'pg_read_all_data'
```

Additionaly, an init script can be run on the main database:
```yaml
postgres_ha_init_script: 'CREATE TABLE example (example TEXT);'
```

Backup settings can be adjusted using:
```yaml
postgres_ha_backup: false
postgres_ha_backup_frequency: 'weekly'
postgres_ha_backup_timeout: 1200
```
If the database is large and a full backup may consume too many server resources (CPU, RAM, disk space), you can configure the system to back up only specific schemas instead of the entire database. This helps optimize backup size and duration. Example:
```yaml
postgres_ha_backup_full: false
postgres_ha_backup_tasks:
  - name: 'partial-dump-of-db'
    included_schema: [ 'important_schema' ]
    excluded_schema: [ 'not_important_schema' ]
```
Fields:
* `name`: An identifier for the backup task.
* `included_schema`: List of schemas to include in the backup.
* `excluded_schema`: List of schemas to exclude from the backup.

And database settings can be modified using the [`ALTER SYSTEM`](https://www.postgresql.org/docs/current/sql-altersystem.html) configuration:
```yaml
postgres_ha_alter_system_settings:
  checkpoint_timeout: '5min'
  max_wal_size: '1GB'
  min_wal_size: '80MB'
```

Container share memory can be configured with:
```yaml
postgres_ha_share_memory: '1g'
```

Metrics exporter for query performance can be activated with:
```yaml
postgres_ha_perf_metrics_exporter_enabled: true
```

# Management

The service is managed using [Docker Compose](https://docs.docker.com/compose/):
```sh
admin@node-01.example.org:/docker/postgres-ha % docker-compose ps
   Name                 Command                 State                    Ports
--------------------------------------------------------------------------------------------
postgres-ha   docker-entrypoint.sh -p 5433   Up (healthy)   5432/tcp, 0.0.0.0:5433->5433/tcp
pg-metrics-exporter   /bin/postgres_exporter         Up             0.0.0.0:9187->9187/tcp
```
