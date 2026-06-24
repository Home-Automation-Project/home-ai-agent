# Services and API Endpoints

## Household AI Services

### household-api
- **URL**: http://localhost:8000
- **Health**: http://localhost:8000/health
- **Container**: household-api (Docker)
- **Status**: [Running/Stopped]
- **Endpoints**:
  - `GET /health` - API health check
  - `GET /integrations/home-assistant/entities` - List HA entities
  - `POST /integrations/google-calendar/events` - Calendar operations
  - `POST /integrations/gmail/draft` - Email drafting
  - `GET /integrations/docker/health` - Docker health status
  - `GET /integrations/library/search` - Library searches
  - `GET /integrations/grocery/inventory` - Grocery items
  - `GET /integrations/water/summary` - Water usage
  - `GET /integrations/vehicles/maintenance` - Maintenance records

### Redis
- **URL**: redis://redis:6379
- **Type**: Cache, pub/sub, queues
- **Status**: [Running/Stopped]
- **Purpose**: Fast state management, event routing

### PostgreSQL
- **URL**: postgresql://household_ai:password@postgres:5432/household_ai
- **Status**: [Running/Stopped]
- **Tables**: audit_logs, confirmations, [custom tables]
- **Backup**: [Backup schedule]

## External Service Endpoints

### Home Assistant
- **URL**: http://had.lthome.us:8123
- **API Base**: http://had.lthome.us:8123/api
- **Authentication**: Long-lived access token
- **Status**: [Check manually]
- **API docs**: http://had.lthome.us:8123/api

### Google Calendar
- **API**: https://www.googleapis.com/calendar/v3
- **Calendar ID**: [Your family calendar ID]
- **Authentication**: OAuth 2.0
- **Rate limit**: 100 requests/minute

### Gmail
- **API**: https://www.googleapis.com/gmail/v1
- **User**: [Your email address]
- **Authentication**: OAuth 2.0
- **Rate limit**: 100 requests/minute

### Grocy
- **URL**: http://grocery.lthome.us
- **API Base**: http://grocery.lthome.us/api
- **Authentication**: API key
- **API docs**: [Grocy API documentation]

### Kavita (Comics)
- **URL**: http://comics.lthome.us
- **API Base**: http://comics.lthome.us/api
- **Authentication**: API key
- **Status**: [Check manually]

### Calibre-Web (Books)
- **URL**: http://books.lthome.us
- **API Base**: http://books.lthome.us/api
- **Authentication**: API key
- **Status**: [Check manually]

### Audiobookshelf (Audiobooks)
- **URL**: http://audiobooks.lthome.us
- **API Base**: http://audiobooks.lthome.us/api
- **Authentication**: API key
- **Status**: [Check manually]

### Immich (Photos)
- **URL**: http://photos.lthome.us
- **API Base**: http://photos.lthome.us/api
- **Authentication**: API key
- **Status**: [Check manually]

### Navidrome (Music)
- **URL**: http://music.lthome.us
- **API Base**: http://music.lthome.us/rest
- **Authentication**: Username/password
- **Status**: [Check manually]

### Water Usage API
- **URL**: [Your water API endpoint]
- **Authentication**: API key
- **Rate limit**: [Check documentation]

### OpenAI
- **API**: https://api.openai.com/v1
- **Model**: gpt-4
- **Authentication**: API key
- **Rate limit**: [Configured in settings]

### Docker (Local)
- **Socket**: unix:///var/run/docker.sock
- **API version**: v1.40+
- **Purpose**: Container health, logs, restart

## Network Availability Checks

### Service Health Status
| Service | URL | Status | Last Check |
|---------|-----|--------|------------|
| household-api | http://localhost:8000/health | [Status] | [Time] |
| Home Assistant | http://had.lthome.us | [Status] | [Time] |
| Grocy | http://grocery.lthome.us | [Status] | [Time] |
| Kavita | http://comics.lthome.us | [Status] | [Time] |
| Calibre-Web | http://books.lthome.us | [Status] | [Time] |
| Audiobookshelf | http://audiobooks.lthome.us | [Status] | [Time] |
| Immich | http://photos.lthome.us | [Status] | [Time] |
| Navidrome | http://music.lthome.us | [Status] | [Time] |

## Service Dependencies

### household-api depends on:
- Redis (for queues and caching)
- PostgreSQL (for audit logs)
- Home Assistant (for HA operations)
- Google APIs (for calendar/email)
- Grocy (for grocery operations)

### Agents depend on:
- household-api (all external interactions)
- Shared memory files
- PostgreSQL (for confirmation and audit logs)

## Credentials Management

### Stored in .env (not committed to git)
- HOME_ASSISTANT_TOKEN
- OPENAI_API_KEY
- GROCY_API_KEY
- KAVITA_API_KEY
- CALIBRE_WEB_API_KEY
- AUDIOBOOKSHELF_API_KEY
- WATER_API_KEY
- GOOGLE_APPLICATION_CREDENTIALS (path)

### Rotation Schedule
- **API keys**: Every 90 days or on compromise
- **Passwords**: Every 180 days
- **OAuth tokens**: Per Google/OpenAI refresh policies

## Monitoring & Alerting

### Health Checks
- **Frequency**: Every 5 minutes
- **Channels**: [Email, Slack, console]
- **Escalation**: [On 3 consecutive failures]

### Logs
- **Aggregation**: [ELK / Loki / other]
- **Retention**: 90 days (configurable)
- **Search**: [How to search logs]

## Notes
[Any additional service notes or configurations]
