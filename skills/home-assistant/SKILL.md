---
name: "home-assistant"
description: "Query and control Home Assistant entities (lights, climate, locks, security)"
category: "home-automation"
risk_level: "high"
requires_confirmation_for: 
  - "unlock_doors"
  - "disarm_security"
  - "disable_automations"
  - "water_shut_off"
allowed_tools:
  - "rest_api"
  - "home_assistant_api"
---

# Home Assistant Skill

## Purpose
Direct interface to Home Assistant via REST API. Execute smart home commands, query entity states, control devices.

## When to Use
- Query entity states (lights, climate, locks, sensors)
- Turn lights on/off, adjust brightness/color
- Set thermostat temperature
- Execute automations or scenes
- Get device status and attributes

## When NOT to Use
- Unlock doors (requires escalation)
- Disarm security system (requires escalation)
- Disable safety-critical automations (requires escalation)
- Make autonomous decisions (use Chief of Staff)

## Required Context
- `home_assistant_url`: Base URL of Home Assistant instance
- `home_assistant_token`: Long-lived access token
- `entity_id`: Target entity identifier (e.g., "light.living_room")
- `entity_domain`: Category of entity (light, climate, lock, switch, etc.)

## Step-by-Step Behavior

### Query Entity State
```
1. Construct GET /api/states/{entity_id}
2. Include Authorization: Bearer {token}
3. Parse response for state and attributes
4. Return formatted state information
5. Log query in audit_logs
```

### Execute Service Call
```
1. Determine service domain and service name
2. Build service_data dictionary
3. POST /api/services/{domain}/{service}
4. Include Authorization and service_data
5. Check response status
6. If confirmation_required: Wait for approval first
7. Log in audit_logs with confirmation status
```

### Execute Scene
```
1. Validate scene exists
2. Call light_scene.turn_on service
3. Wait for completion
4. Verify scene activated
5. Log in audit_logs
```

## Safety Rules (MANDATORY)
- **Never unlock doors without confirmation**
- **Never disarm security without confirmation**
- **Never disable safety automations**
- **Never override manual controls for 30 minutes**
- **Always check entity exists before operating**
- **Log all operations to audit_logs**

## Example User Requests

**Request**: "Turn on the living room light"
**Response**: 
```
Turning on the living room light...
Light state changed from 'off' to 'on'
✓ Complete
```

**Request**: "What's the current temperature?"
**Response**:
```
Current climate state:
- Current temperature: 72°F
- Target temperature: 71°F
- Mode: heating
- Last updated: 2 minutes ago
```

**Request**: "Unlock the front door"
**Response**:
```
Confirmation required: Unlock the front door?
This action requires your approval.
Waiting for confirmation (timeout: 300s)...
[User confirms]
Front door unlocked successfully ✓
```

## Failure Handling

**Connection Failed**:
- Retry up to 3 times with exponential backoff
- Escalate to sysadmin if persistent
- Return: "Unable to connect to Home Assistant"

**Entity Not Found**:
- Check entity_id spelling
- Return: "Entity 'light.unknown' does not exist"
- Suggest similar entities if available

**Service Call Failed**:
- Log error to audit_logs
- Return specific error from Home Assistant
- Escalate if safety-critical

**Confirmation Timeout**:
- Cancel operation
- Log timeout in audit_logs
- Return: "Operation cancelled - confirmation timeout"

## Implementation Notes
- Endpoint: `POST /integrations/home-assistant/call-service`
- Mock mode: Returns mock entity data
- Rate limit: 10 requests/second per entity
- Timeout: 10 seconds per request
