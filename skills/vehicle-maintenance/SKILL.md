---
name: "vehicle-maintenance"
description: "Track vehicle maintenance history and schedule service"
category: "vehicles"
risk_level: "medium"
requires_confirmation_for:
  - "schedule_major_service"
allowed_tools:
  - "rest_api"
---

# Vehicle Maintenance Skill

## Purpose
Manage vehicle maintenance records, track service schedules, provide maintenance reminders.

## When to Use
- View maintenance history
- Check upcoming service dates
- Log completed maintenance
- Get maintenance reminders
- Calculate mileage-based service needs
- Track maintenance costs

## When NOT to Use
- Delete maintenance records
- Modify historical data
- Ignore critical service needs
- Make service appointments autonomously

## Step-by-Step Behavior

### Query Maintenance History
```
1. Load vehicle memory file
2. Parse maintenance records
3. Sort by date/mileage
4. Return formatted history
```

### Calculate Service Due
```
1. Get current vehicle mileage
2. Query maintenance schedule
3. Calculate intervals (mileage and time)
4. Identify upcoming service
5. Return prioritized service list
```

### Log Maintenance
```
1. Record completed service
2. Update vehicle mileage
3. Calculate next service date
4. Update memory file
5. Log in audit_logs
```

## Safety Rules
- **Never delete maintenance records**
- **Maintain accurate service history**
- **Respect manufacturer schedules**
- **Alert to overdue maintenance**
- **Track all major service**

## Example Requests

**Request**: "When is the next oil change due?"
**Response**:
```
2013 Ford F-150 Maintenance Schedule:

Current mileage: 125,400 miles
Next oil change: 130,000 miles (4,600 miles away)
Estimated date: 3-4 months

Other upcoming:
- Tire rotation: 126,000 miles (nearby)
- Air filter inspection: 128,000 miles
- Coolant flush: 135,000 miles
```

**Request**: "Show maintenance history"
**Response**:
```
2013 Ford F-150 Service History:

2026:
- June 15: Oil change (125,400 mi) - $45
- May 20: Tire rotation (124,800 mi) - $30

2025:
- Oct 10: Air filter replacement (120,000 mi) - $25
- Aug 05: Major service (115,000 mi) - $450

Total maintenance (2 years): $550
```

**Request**: "Log an oil change"
**Response**:
```
Logging oil change for 2013 Ford F-150

Current mileage? 128,400
Oil type? 5W-30 Synthetic
Cost? $45

✓ Oil change recorded
Next oil change due at: 133,400 miles
```

## Implementation Notes
- Data source: memory/vehicles/*.md files
- Mock mode: Returns mock maintenance data
- Service intervals: Manufacturer + vehicle-specific
- Reminders: 500 miles or 2 weeks before due
- Timeout: 5 seconds
