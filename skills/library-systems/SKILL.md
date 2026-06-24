---
name: "library-systems"
description: "Search and recommend books, comics, audiobooks"
category: "entertainment"
risk_level: "low"
requires_confirmation_for: []
allowed_tools:
  - "kavita_api"
  - "calibre_web_api"
  - "audiobookshelf_api"
  - "rest_api"
---

# Library Systems Skill

## Purpose
Interface to Kavita (comics), Calibre-Web (books), and Audiobookshelf (audiobooks). Search and recommend content.

## When to Use
- Search across all library systems
- Get personalized recommendations
- Check if content available
- Track reading progress
- Manage reading lists
- Query collections and series

## When NOT to Use
- Purchase content (escalate)
- Modify library configurations
- Delete content
- Change access permissions

## Step-by-Step Behavior

### Search Libraries
```
1. Parse search query and library type filter
2. Query appropriate system(s)
3. Merge results from all systems
4. Rank by relevance
5. Return formatted results
```

### Get Recommendations
```
1. Load family member reading preferences
2. Query reading history
3. Analyze content preferences and restrictions
4. Generate personalized recommendations
5. Return ranked list with reasoning
```

### Track Reading Progress
```
1. Query current reading status
2. Compare to reading goals
3. Provide encouragement/suggestions
4. Alert if deadlines approaching
```

## Safety Rules
- **Respect content sensitivity settings**
- **Always filter by reading preferences**
- **Never push age-inappropriate content**
- **Honor series/author dislikes**

## Example Requests

**Request**: "Recommend a sci-fi book"
**Response**:
```
Based on your reading preferences, here are recommendations:

1. "Project Hail Mary" by Andy Weir
   ✓ Hard sci-fi (your favorite)
   ✓ Available in Calibre-Web
   ✓ No content concerns for you

2. "The Three-Body Problem" by Liu Cixin
   ✓ Space opera sci-fi
   ✓ Available in Calibre-Web
   
3. "Gideon the Ninth" by Tamsyn Muir
   ✓ Gothic sci-fi
   ✓ Available (note: contains violence)
```

**Request**: "Show my reading progress"
**Response**:
```
Reading Status:
Current book: "Dune" by Frank Herbert (45% complete)
Books this month: 2/3 (on track!)
Reading streak: 23 days ✓

Next recommended: "Mistborn" by Brandon Sanderson
```

## Implementation Notes
- Endpoint: `GET /integrations/library/search`
- Mock mode: Returns mock library results
- Rate limit: 20 requests/minute
- Timeout: 10 seconds
