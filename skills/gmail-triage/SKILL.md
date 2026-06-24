---
name: "gmail-triage"
description: "Read, summarize, and draft email replies"
category: "communication"
risk_level: "medium"
requires_confirmation_for:
  - "send_email"
allowed_tools:
  - "google_gmail_api"
  - "rest_api"
---

# Gmail Triage Skill

## Purpose
Read Gmail inbox, summarize messages, draft replies without sending.

## When to Use
- Summarize inbox by category/sender
- Read and summarize important emails
- Draft replies to emails
- Flag important messages
- Organize email by label

## When NOT to Use
- Send emails without confirmation
- Delete emails permanently
- Access other users' email
- Auto-reply or automate sending

## Step-by-Step Behavior

### Summarize Inbox
```
1. Query Gmail inbox
2. Group by sender or label
3. Summarize each email
4. Highlight important messages
5. Return prioritized summary
```

### Draft Reply
```
1. Read original email
2. Compose reply draft
3. Request confirmation
4. Store in Drafts (do not send)
5. Return draft for review
```

## Safety Rules
- **Never send email without confirmation**
- **Never delete emails without confirmation**
- **Never modify email settings autonomously**

## Example Requests

**Request**: "What's in my inbox today?"
**Response**:
```
Inbox summary (5 messages):
1. Boss - "Project update needed" [IMPORTANT]
2. Newsletter - "Weekly digest"
3. Friend - "Coffee this weekend?"
4. Store - "Shipping confirmation"
5. System - "Password reset confirmation"
```

**Request**: "Draft a reply to the coffee message"
**Response**:
```
Draft reply to Friend:
---
Thanks! I'd love to get coffee this weekend. How about Saturday at 10 AM at our usual place?
---

Ready to review. Send? (yes/no)
```

## Implementation Notes
- Endpoint: `POST /integrations/gmail/draft`
- Mock mode: Returns mock emails
- Rate limit: 5 requests/minute
- Timeout: 20 seconds
