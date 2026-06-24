---
name: "google-calendar"
description: "Query and manage Google Calendar events"
category: "family-coordination"
risk_level: "medium"
requires_confirmation_for:
  - "create_event"
  - "modify_event"
  - "delete_event"
allowed_tools:
  - "google_calendar_api"
  - "rest_api"
---

# Google Calendar Skill

## Purpose
Interface to Google Calendar. Query events, find availability, draft events, coordinate schedules.

## When to Use
- List events for specific date/time range
- Check availability for individual or group
- Find common availability windows
- Draft meeting invitations
- Detect scheduling conflicts

## When NOT to Use
- Modify events without confirmation
- Delete events without confirmation
- Override family member preferences
- Make autonomous scheduling decisions

## Required Context
- `google_calendar_id`: Calendar ID to query
- `google_application_credentials`: OAuth2 credentials JSON
- `date_range`: Start and end dates for query

## Step-by-Step Behavior

### List Events
```
1. Call Google Calendar API
2. Query date range specified
3. Parse event list
4. Return formatted events with times
5. Log query in audit_logs
```

### Find Availability
```
1. Query all family calendars
2. Identify free time slots
3. Compare across all calendars
4. Return common availability
5. Suggest optimal meeting times
```

### Draft Event
```
1. Prepare event details (title, time, attendees)
2. Request confirmation
3. Wait for approval
4. Create event in calendar
5. Log in audit_logs with confirmation
```

## Safety Rules
- **Always confirm event creation**
- **Always confirm event modification**
- **Always confirm event deletion**
- **Respect individual calendar ownership**
- **Never modify without explicit permission**

## Example Requests

**Request**: "What's on the calendar tomorrow?"
**Response**:
```
Tomorrow's calendar (June 24):
- 09:00-10:00: Team standup (work)
- 12:00-13:00: Lunch meeting
- 15:30-16:30: Doctor appointment
- 19:00: Family dinner reservation

Free time: 10:00-12:00, 13:00-15:30, after 16:30
```

**Request**: "Find a time tomorrow when everyone is available"
**Response**:
```
Checking availability for: You, Person2, Person3

Available windows:
- 10:00-12:00 (2 hours) ✓ Everyone free
- 13:00-14:00 (1 hour) ✓ Everyone free

Recommend: 10:00-11:00 AM slot
```

**Request**: "Schedule a meeting at 10 AM"
**Response**:
```
Confirmation required: Create calendar event
- Title: Meeting
- Time: Tomorrow 10:00 AM
- Attendees: (specify)

Approve? (yes/no)
[User confirms]
Event created ✓
```

## Failure Handling
- **Connection failed**: Retry or return cached calendar data
- **Permission denied**: Return error and escalate
- **Event not found**: Return "Event does not exist"
- **Timeout**: Return "Calendar service unavailable"

## Implementation Notes
- Endpoint: `GET /integrations/google-calendar/events`
- Mock mode: Returns mock events
- Rate limit: 10 requests/minute
- Timeout: 15 seconds per request
