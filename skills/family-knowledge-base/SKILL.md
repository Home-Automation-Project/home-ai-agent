---
name: "family-knowledge-base"
description: "Query and manage family knowledge, preferences, and household rules"
category: "knowledge-management"
risk_level: "low"
requires_confirmation_for: []
allowed_tools:
  - "rest_api"
  - "memory_system"
---

# Family Knowledge Base Skill

## Purpose
Access family preferences, rules, routines, and shared knowledge stored in memory files.

## When to Use
- Query family member preferences
- Get household routines and schedules
- Check safety rules and automation rules
- Get device/room information
- Query family profiles
- Access system knowledge (HA entities, services)

## When NOT to Use
- Modify memory files (read-only)
- Delete knowledge entries
- Override stored preferences
- Make decisions based on outdated info

## Step-by-Step Behavior

### Query Family Preferences
```
1. Load memory/household/family-profile.md
2. Look up specific family member
3. Extract preferences (scheduling, food, entertainment)
4. Return formatted preferences
```

### Access Household Routines
```
1. Load memory/household/routines.md
2. Query routine type (morning, evening, away, etc.)
3. Return timing and automation sequence
4. Note any conditionals or exceptions
```

### Check Safety Rules
```
1. Load memory/household/safety-rules.md
2. Parse critical safety rules
3. Check specific rule category
4. Return rule and enforcement level
```

### Query System Knowledge
```
1. Load relevant system memory files
   - home-assistant.md (entity groups, automations)
   - docker-hosts.md (containers, hosts)
   - network-map.md (IP scheme, devices)
   - services.md (endpoints, health)
2. Format requested information
3. Return structured data
```

## Safety Rules
- **Never modify memory files from this skill**
- **Use read-only access only**
- **Respect family member privacy**
- **Always validate info before using in decisions**
- **Update memory through proper channels only**

## Example Requests

**Request**: "What are the safety rules?"
**Response**:
```
Critical Safety Rules:

Level CRITICAL:
✓ Never unlock doors without confirmation
✓ Never disable security system without confirmation
✓ Never shut off water main without explicit reason

Level HIGH:
✓ Never override safety automations
✓ Never allow unknown water usage spikes
✓ Alert on occupancy sensor failures

Level MEDIUM:
✓ Respect manual control overrides (30 min cooldown)
✓ Maintain climate within comfort range

See: memory/household/safety-rules.md for full details
```

**Request**: "What's the evening routine?"
**Response**:
```
Evening Routine (9:00 PM):

Sequence:
1. Dim all lights gradually (30 min)
2. Close blinds in living areas
3. Set climate to comfort temperature
4. Security pre-check (doors, windows)
5. Evening entertainment setup available

Duration: ~15 minutes
Manual override: 30 min cooldown if interrupted

See: memory/household/routines.md for full details
```

**Request**: "What's the family dietary info?"
**Response**:
```
Dietary Preferences:

Family Member 1:
- Allergies: None
- Intolerances: None
- Dislikes: Mushrooms, olives
- Preferences: Spicy food, Asian cuisine
- Dietary style: Omnivore

Family Member 2:
- Allergies: Peanuts (severe)
- Intolerances: Lactose (moderate)
- Dislikes: Seafood
- Preferences: Mediterranean, Italian
- Dietary style: Pescatarian

See: memory/food/pantry-rules.md for complete info
```

**Request**: "List all Home Assistant entity groups"
**Response**:
```
Home Assistant Entity Groups:

Climate:
- climate.main_floor (thermostat)
- climate.basement (additional zone)

Lighting:
- light.living_room, light.bedroom, light.kitchen...

Locks:
- lock.front_door, lock.back_door, lock.garage

Security:
- alarm_control_panel.home_alarm
- binary_sensor.motion_detector_*

Water:
- sensor.water_usage, sensor.water_flow
- switch.water_main (manual only)

See: memory/systems/home-assistant.md for full inventory
```

## Implementation Notes
- Data source: All files in memory/ directory
- Access pattern: Read-only file access
- Cache: Update when files change
- Format: Markdown to structured data parsing
- Timeout: 2 seconds
