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

  - name: my-other-db
    user: my-other-user
    pass: my-other-pass
```
The `user` field is optional. DB name is used by default.

:warning: __WARNING:__ This only takes effect at database creation.

Backup settings can be adjusted using:
```yaml
postgres_ha_backup: false
postgres_ha_backup_frequency: 'weekly'
postgres_ha_backup_timeout: 1200
```

# Management

The service is managed using [Docker Compose](https://docs.docker.com/compose/):
```sh
admin@node-01.example.org:/docker/postgres-ha % docker-compose ps
   Name                 Command                 State                    Ports
--------------------------------------------------------------------------------------------
postgres-ha   docker-entrypoint.sh -p 5433   Up (healthy)   5432/tcp, 0.0.0.0:5433->5433/tcp
```
