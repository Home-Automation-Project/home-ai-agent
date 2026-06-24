# Docker Hosts and Container Inventory

## Docker Hosts

### Local Docker (Primary)
- **Type**: Docker daemon on local machine
- **URL**: unix:///var/run/docker.sock
- **OS**: [Linux, Windows, macOS]
- **Version**: [Docker version]
- **Storage**: [Storage driver, e.g., overlay2]
- **Networking**: [Default bridge, custom networks]
- **Resources**: 
  - CPU: [Number of cores allocated]
  - RAM: [GB allocated]
  - Storage: [GB available]

### Raspberry Pi 1 (docker-pi-01)
- **Type**: Remote Docker host
- **URL**: tcp://docker-pi-01.lthome.us:2375
- **OS**: Raspberry Pi OS
- **Model**: [Raspberry Pi 4B/5/etc.]
- **RAM**: [GB]
- **Storage**: [SD card or SSD size]
- **Purpose**: [Sensor nodes, edge compute, etc.]
- **Connected devices**: [Aqara hub, other hardware]

### Raspberry Pi 2 (docker-pi-02)
- **Type**: Remote Docker host
- **URL**: tcp://docker-pi-02.lthome.us:2375
- **OS**: Raspberry Pi OS
- **Model**: [Raspberry Pi model]
- **Purpose**: [Purpose on this host]

## Container Inventory

### Core Services (Local Docker)

#### household-api
- **Image**: household-ai-api:latest
- **Port**: 8000
- **Status**: [Running/Stopped]
- **Resources**: CPU=1, Memory=512MB
- **Restart policy**: unless-stopped
- **Logs**: Check with `docker logs household-api`
- **Health check**: `/health` endpoint

#### Redis
- **Image**: redis:7-alpine
- **Port**: 6379
- **Status**: [Running/Stopped]
- **Resources**: CPU=0.5, Memory=256MB
- **Restart policy**: unless-stopped
- **Data**: /data volume (persistent)
- **Purpose**: Pub/sub, queues, caching

#### PostgreSQL
- **Image**: postgres:15-alpine
- **Port**: 5432
- **Status**: [Running/Stopped]
- **Resources**: CPU=1, Memory=1GB
- **Restart policy**: unless-stopped
- **Data**: /var/lib/postgresql/data (persistent)
- **Purpose**: Audit logs, persistent state

### Home Automation Services

#### Home Assistant
- **Host**: Local or remote
- **URL**: had.lthome.us:8123
- **Container**: [If containerized]
- **Backup**: [Backup schedule and location]

#### [Additional services]

## Allowlist for Restart

Services that agents can safely restart:
- `household-api` - Safe to restart
- `redis` - Safe to restart (ephemeral data)
- `postgres` - **Careful**: Shutdown requires data flush, but safe
- [Other allowlisted services]

### Never Restart Without Approval
- [Critical services]
- [Services with long startup times]

## Backup Strategy

### Daily Backups
- **Time**: 2:00 AM daily
- **Services**:
  - PostgreSQL dump
  - Redis RDB snapshot
  - Configuration backup
- **Retention**: 7 days
- **Storage**: [Local and/or cloud backup location]

### Weekly Backups
- **Time**: Sunday 3:00 AM
- **Retention**: 4 weeks
- **Storage**: [Backup location]

### Monthly Archive
- **Time**: 1st of month 4:00 AM
- **Retention**: 12 months
- **Storage**: [Archive location]

## Monitoring

### Container Health Checks
- **Interval**: Every 30 seconds
- **Unhealthy threshold**: 3 failed checks
- **Restart on unhealthy**: Enabled

### Resource Monitoring
- **CPU threshold alert**: >80%
- **Memory threshold alert**: >80%
- **Disk threshold alert**: >85%
- **Check frequency**: Every minute

### Log Aggregation
- **Driver**: json-file
- **Max size**: 10MB per file
- **Max files**: 3 per container
- **Collection**: [ELK stack / other logging solution]

## Network Configuration

### Docker Networks
- **household-internal**: Internal bridge network for service-to-service communication
- **Subnet**: 172.25.0.0/16

### Port Mappings
- 8000: household-api (external access)
- 5432: postgres (internal only)
- 6379: redis (internal only)
- [Other exposed ports]

## Disaster Recovery

### RTO (Recovery Time Objective): [Time in minutes]
### RPO (Recovery Point Objective): [Time in minutes/hours]

### Backup Restoration Process
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Runbook
- [Link to disaster recovery runbook]

## Known Issues

### [Issue]
- **Description**: [Describe]
- **Workaround**: [Workaround]
- **Status**: [Open/In progress/Resolved]

## Notes
[Any additional Docker configuration notes]
