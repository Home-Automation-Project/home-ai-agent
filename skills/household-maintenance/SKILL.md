---
name: "household-maintenance"
description: "Track home maintenance, repairs, and upkeep schedules"
category: "home-maintenance"
risk_level: "medium"
requires_confirmation_for: []
allowed_tools:
  - "rest_api"
---

# Household Maintenance Skill

## Purpose
Manage home maintenance records, track repair history, maintain upkeep schedules.

## When to Use
- View home repair history
- Check maintenance schedules (HVAC, roof, etc.)
- Log completed home improvements
- Get maintenance reminders
- Track maintenance costs
- Prepare for seasonal maintenance

## When NOT to Use
- Make repairs autonomously
- Delete maintenance records
- Modify historical data
- Ignore critical maintenance needs

## Step-by-Step Behavior

### Query Maintenance Records
```
1. Load household memory files
2. Compile maintenance history
3. Organize by category (HVAC, roof, plumbing, etc.)
4. Return formatted records
```

### Identify Due Maintenance
```
1. Check maintenance schedules
2. Calculate time/mileage until next service
3. Alert to overdue items
4. Prioritize by urgency
5. Return actionable maintenance list
```

### Log Completed Work
```
1. Record maintenance completion
2. Update service date
3. Document costs and contractor info
4. Note any issues found
5. Update memory files
```

## Safety Rules
- **Maintain accurate service records**
- **Respect seasonal maintenance needs**
- **Alert to critical repairs**
- **Track contractor information**
- **Document warranty coverage**

## Example Requests

**Request**: "What home maintenance is due soon?"
**Response**:
```
Home Maintenance Status:

Due within 1 month:
- HVAC filter replacement (due June 30)
- Gutter cleaning (before rainy season)

Due within 3 months:
- Annual furnace inspection (July/August)
- Power washing deck (summer prep)
- Caulk bathroom (moisture issue)

Overdue:
- Roof inspection (annual - last done Jan 2025)
```

**Request**: "Show roof maintenance history"
**Response**:
```
Roof Maintenance History:

2025:
- Jan 15: Professional inspection - No issues found ($200)

2024:
- Oct 20: Emergency leak repair - Storm damage ($500)
- Sep 10: Gutter cleaning ($150)

Last major work: 2020 - Roof replaced ($8,500)
Warranty: 20-year manufacturer warranty (expires 2040)

Next: Annual inspection (due now)
```

## Implementation Notes
- Data source: Future household-maintenance.md in memory/
- Seasonal tracking: Spring, summer, fall, winter
- Contractor management: Contact info, warranty tracking
- Cost tracking: Budget planning and ROI analysis
- Timeout: 5 seconds
