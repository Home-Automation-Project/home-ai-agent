---
name: "water-usage-monitor"
description: "Query water usage and detect leaks"
category: "utilities"
risk_level: "high"
requires_confirmation_for:
  - "shut_off_water"
allowed_tools:
  - "water_api"
  - "home_assistant_api"
  - "rest_api"
---

# Water Usage Monitor Skill

## Purpose
Monitor household water usage, detect anomalies and leaks, provide conservation suggestions.

## When to Use
- Query daily/weekly/monthly water usage
- Check for leak indicators
- Get water conservation suggestions
- Monitor usage trends
- Alert on unusual patterns
- Analyze usage by time of day

## When NOT to Use
- Shut off water main autonomously (requires escalation)
- Ignore leak alerts
- Modify sensor configuration
- Delete usage history

## Step-by-Step Behavior

### Query Water Usage
```
1. Connect to water API
2. Get usage for specified period
3. Calculate daily average
4. Compare to historical baseline
5. Return formatted usage report
```

### Detect Leaks
```
1. Monitor water flow continuously
2. Compare to baseline patterns
3. Alert if usage > 125% of baseline
4. Flag if midnight usage detected
5. Escalate if confirmed leak
```

### Usage Analysis
```
1. Break down usage by time of day
2. Identify peak usage hours
3. Compare to family schedule
4. Suggest optimization opportunities
5. Return analysis with recommendations
```

## Safety Rules
- **NEVER shut off water autonomously**
- **Always escalate suspected leaks**
- **Maintain leak detection sensitivity**
- **Log all anomalies**
- **Alert immediately on critical leaks**

## Example Requests

**Request**: "How much water did we use today?"
**Response**:
```
Water usage today: 45 gallons
- Daily average: 38 gallons
- Usage: +18% above normal

Time breakdown:
- Morning (6-10 AM): 18 gallons
- Afternoon (10 AM-6 PM): 12 gallons
- Evening (6 PM-midnight): 15 gallons

No unusual patterns detected ✓
```

**Request**: "Is there a water leak?"
**Response**:
```
Checking for leaks...

Analysis:
- Current flow: 0.0 GPM (normal)
- Midnight usage: 0 gallons (normal)
- Last 24 hours: No anomalies

Status: ✓ No leaks detected
```

**Request**: "How can I save water?"
**Response**:
```
Water conservation suggestions:

Based on your usage patterns:
1. Morning showers are using 35% of daily water
   → Consider shorter showers (could save 10 gal/day)
   
2. Toilet flushes are detecting higher usage
   → Check for leaks (suggest professional inspection)
   
3. Outdoor watering (Tuesdays/Fridays)
   → Could reduce by 50% during rainy seasons

Potential savings: 15 gallons/day = ~450 gal/month
```

## Failure Handling
- **API unavailable**: Use cached historical data
- **Sensor disconnected**: Alert immediately
- **Invalid readings**: Flag for investigation
- **Anomaly unconfirmed**: Continue monitoring

## Implementation Notes
- Endpoint: `GET /integrations/water/summary`
- Mock mode: Returns mock water data
- Update frequency: Every 5 minutes
- Leak detection threshold: 125% of baseline
- Timeout: 10 seconds
