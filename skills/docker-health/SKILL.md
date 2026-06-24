---
name: "docker-health"
description: "Query Docker container status and logs"
category: "system-administration"
risk_level: "critical"
requires_confirmation_for:
  - "restart_container"
allowed_tools:
  - "docker_api"
  - "rest_api"
---

# Docker Health Skill

## Purpose
Monitor Docker containers and Raspberry Pi deployments. Query status, logs, resource usage.

## When to Use
- Check container status (running/stopped)
- View container logs for debugging
- Monitor resource usage (CPU, memory)
- Verify deployment health
- Collect system diagnostics

## When NOT to Use
- Restart containers autonomously (requires confirmation)
- Modify container configuration
- Delete containers or volumes
- Make system changes without escalation

## Step-by-Step Behavior

### Query Container Status
```
1. Connect to Docker daemon
2. List all containers
3. Gather status, health, resource usage
4. Return formatted status
5. Log query in audit_logs
```

### View Container Logs
```
1. Query specific container logs
2. Parse for errors/warnings
3. Return last N lines with timestamps
4. Highlight error patterns
```

### Restart Allowlisted Container
```
1. Check if container in allowlist
2. Request confirmation if needed
3. Execute container restart
4. Wait for healthy status
5. Log in audit_logs with confirmation
```

## Safety Rules
- **Never restart database or API containers without confirmation**
- **Never forcefully kill containers**
- **Only restart allowlisted containers**
- **Always log container operations**
- **Escalate persistent failures**

## Example Requests

**Request**: "Check Docker health"
**Response**:
```
Docker Status:
✓ household-api: running (healthy, 145MB mem)
✓ redis: running (healthy, 52MB mem)
✓ postgres: running (healthy, 283MB mem)
✓ pi-01: connected (3 containers running)

All systems healthy ✓
```

**Request**: "Show household-api logs"
**Response**:
```
household-api logs (last 10 lines):
2026-06-23 12:45:32 INFO: Started API server
2026-06-23 12:45:33 INFO: Connected to database
2026-06-23 12:45:34 INFO: Connected to Redis
2026-06-23 12:46:01 INFO: GET /health (200ms)
...
```

## Failure Handling
- **Connection failed**: Escalate to sysadmin
- **Container unhealthy**: Alert for investigation
- **Resource critical**: Alert and escalate
- **Persistent errors**: Suggest container restart (with confirmation)

## Implementation Notes
- Endpoint: `GET /integrations/docker/health`
- Mock mode: Returns mock container status
- Allowlist: Config in permissions.yaml
- Timeout: 10 seconds
