# Household AI Assistant System

A self-hosted AI assistant system designed to integrate with your home automation infrastructure. This system is built as a collection of OpenClaw-compatible agents and skills that coordinate through a central API gateway, message queue, and shared memory layer.

## Overview

**Purpose**: Provide a unified, intelligent interface to monitor, control, and optimize your household systems across Home Assistant, media libraries, meal planning, maintenance tracking, water monitoring, and more.

**How It Works**: 
- OpenClaw acts as your **agent orchestrator** — it runs multiple AI agents that handle different household domains (home automation, meals, calendar, etc.)
- Each agent has access to **skills** (tools) that let it query and control external systems
- Agents share a **unified memory** layer so they can coordinate (e.g., "Person arriving at 5 PM" → home agent prepares house, meal agent plans dinner)
- All actions are **audit-logged** with optional user confirmation gates for safety-critical operations

**Architecture**:
- **OpenClaw** (Container on port 8001): Agent orchestrator — loads agents, dispatches skills, manages agent sessions
- **Agents** (8 total): household-chief-of-staff, home-automation, librarian, meal-planner, sysadmin, family-calendar, water-monitor, vehicle-maintenance
- **Skills** (11 total): home-assistant, google-calendar, gmail-triage, docker-health, library-systems, grocery-inventory, meal-planning, water-usage-monitor, vehicle-maintenance, household-maintenance, family-knowledge-base
- **Integration Layer** (FastAPI on port 8000): household-api bridges agent skills to external services (Home Assistant, Google Calendar, Gmail, Docker, water API, etc.)
- **State Layer**: Redis (pub/sub, queues, caching) + Postgres (audit logs, persistent state, confirmations)
- **Memory**: Shared markdown/YAML files accessible to all agents and humans

## Quick Start

### Prerequisites
- Docker & Docker Compose
- API credentials for external services (see `.env.example`)
- Optional: Custom OpenClaw image (uses default `lantern-ai/openclaw:latest` if not specified)

### Setup

```bash
# Clone and navigate to repo
cd household-ai

# Copy environment template
cp .env.example .env

# Edit .env with your credentials
# - OPENAI_API_KEY
# - HOME_ASSISTANT_TOKEN
# - GOOGLE_CALENDAR_CREDENTIALS_FILE
# - OPENCLAW_API_KEY (if using authenticated OpenClaw)
# - OPENCLAW_IMAGE (optional, defaults to lantern-ai/openclaw:latest)
# - etc.

# Start all services (including containerized OpenClaw)
docker-compose up -d

# Verify all services are healthy
docker-compose ps
curl http://localhost:8001/health       # OpenClaw
curl http://localhost:8000/health       # household-api

# View startup logs
docker-compose logs -f
```

### First Test Workflow

1. **Verify all services running**:
   ```bash
   docker-compose ps
   # Should show: postgres, redis, openclaw, household-api all running
   ```

2. **Access OpenClaw Web UI**:
   ```bash
   # Open browser to OpenClaw control panel
   http://localhost:8001
   # (exact path depends on OpenClaw version; typically /dashboard or /ui)
   ```

3. **Check OpenClaw health**:
   ```bash
   curl http://localhost:8001/health
   ```

4. **Check API health**:
   ```bash
   curl http://localhost:8000/health
   ```

5. **Test Home Assistant integration**:
   ```bash
   curl http://localhost:8000/integrations/home-assistant/entities
   ```

6. **Invoke an agent via OpenClaw** (syntax depends on OpenClaw version):
   ```bash
   # Example: Query OpenClaw for agents
   curl http://localhost:8001/agents
   ```

7. **Check audit logs**:
   ```bash
   docker-compose exec postgres psql -U household_ai -d household_ai -c "SELECT * FROM audit_logs LIMIT 10;"
   ```

8. **View container logs**:
   ```bash
   docker-compose logs -f openclaw
   docker-compose logs -f household-api
   ```

---

## OpenClaw Setup & Configuration

### What is OpenClaw?

OpenClaw is a **multi-channel AI gateway** that manages agents, handles agent routing, manages sessions, and provides APIs/CLIs for invoking agents. In this project, OpenClaw is containerized and acts as the central orchestrator for all household agents.

**Key capabilities**:
- **Agent discovery**: Automatically loads agents from `/app/agents/` directory
- **Skill dispatch**: Routes agent requests to skills (via household-api)
- **Session management**: Tracks agent sessions and user conversations
- **Web UI**: Browser-based control panel for monitoring and testing
- **CLI & API**: Command-line and REST API for programmatic access
- **Multi-channel**: Supports Discord, Slack, Telegram, WebChat, and more (optional)

### OpenClaw Configuration

OpenClaw stores its configuration in a persistent Docker volume:
- **Location in container**: `/root/.openclaw/`
- **Config file**: `openclaw.json`
- **Docker volume**: `openclaw_data` (defined in docker-compose.yml)

**This volume persists across container reboots**, ensuring your OpenClaw settings survive restarts.

### OpenClaw Environment Variables

The `openclaw` service in docker-compose.yml is configured with:

```yaml
environment:
  OPENCLAW_LOG_LEVEL: ${OPENCLAW_LOG_LEVEL:-INFO}
  OPENCLAW_API_PORT: 8001
  OPENCLAW_DATABASE_URL: postgresql://[credentials]@postgres:5432/household_ai
  OPENCLAW_REDIS_URL: redis://redis:6379
  OPENCLAW_AGENTS_PATH: /app/agents
  OPENCLAW_SKILLS_PATH: /app/skills
  OPENCLAW_MEMORY_PATH: /app/memory
```

**What these do**:
- `OPENCLAW_LOG_LEVEL`: Set to DEBUG for verbose logging, INFO for normal
- `OPENCLAW_API_PORT`: Listens on port 8001
- `OPENCLAW_DATABASE_URL`: Connects to shared PostgreSQL database (agents, sessions, audit logs)
- `OPENCLAW_REDIS_URL`: Connects to shared Redis for pub/sub and caching
- `OPENCLAW_AGENTS_PATH`: Where OpenClaw discovers agent definitions
- `OPENCLAW_SKILLS_PATH`: Where OpenClaw discovers skill definitions
- `OPENCLAW_MEMORY_PATH`: Shared memory directory for all agents

### Initial OpenClaw Setup

When you start OpenClaw for the first time:

1. **Container starts**, loads agents from `./agents/` directory
2. **Discovers skills** from `./skills/` directory
3. **Creates `openclaw.json`** in persistent volume (`openclaw_data`)
4. **Initializes database** connections
5. **Starts API** on port 8001

**No manual registration needed** — agent discovery is automatic based on directory structure.

### Configuring OpenClaw

To customize OpenClaw behavior:

1. **After first startup**, find the config file:
   ```bash
   # View the persistent config (mounted from openclaw_data volume)
   docker-compose exec openclaw cat /root/.openclaw/openclaw.json
   ```

2. **Edit the config** (example: restrict channels, set log level):
   ```bash
   # Copy out, edit locally, copy back
   docker cp household-ai-openclaw:/root/.openclaw/openclaw.json ./openclaw.json.bak
   nano openclaw.json.bak
   docker cp ./openclaw.json.bak household-ai-openclaw:/root/.openclaw/openclaw.json
   docker-compose restart openclaw
   ```

3. **Or use environment variables** in `.env`:
   ```bash
   OPENCLAW_LOG_LEVEL=DEBUG
   ```

### Agent & Skill Discovery

**Agents** are auto-discovered from `./agents/` directory:
```
agents/
├── household-chief-of-staff/
│   ├── agent.yaml         # Agent definition
│   └── instructions.md    # Detailed behavior
├── home-automation/
│   ├── agent.yaml
│   └── instructions.md
└── ... (6 more agents)
```

**Skills** are auto-discovered from `./skills/` directory:
```
skills/
├── home-assistant/
│   └── SKILL.md           # Skill with YAML frontmatter
├── google-calendar/
│   └── SKILL.md
└── ... (9 more skills)
```

OpenClaw reads these files on startup and registers agents/skills automatically.

### Accessing OpenClaw Web UI

OpenClaw provides a browser-based control panel:

```bash
# Once containers are running
http://localhost:8001
# or
http://localhost:8001/dashboard
# or
http://localhost:8001/ui
# (exact path varies by OpenClaw version)
```

**In the UI, you can**:
- View registered agents
- View available skills
- Test agent invocation
- Monitor sessions
- View configuration
- Check logs and health

### OpenClaw API

You can interact with OpenClaw via REST API:

```bash
# List agents
curl http://localhost:8001/agents

# List skills
curl http://localhost:8001/skills

# Health check
curl http://localhost:8001/health

# Invoke an agent (example)
curl -X POST http://localhost:8001/agents/household-chief-of-staff/invoke \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Summarize household status"}'
```

**API documentation**: See OpenClaw GitHub repo or run:
```bash
curl http://localhost:8001/docs
```

### OpenClaw Data Persistence

Three types of persistence:

| Component | Storage | Location | Persists? |
|-----------|---------|----------|-----------|
| Agent definitions | Local filesystem | `./agents/` | ✅ Yes (committed to git) |
| Skill definitions | Local filesystem | `./skills/` | ✅ Yes (committed to git) |
| Shared memory | Local filesystem | `./memory/` | ✅ Yes (committed to git) |
| OpenClaw config | Docker volume | `openclaw_data` → `/root/.openclaw/` | ✅ Yes (volume survives reboots) |
| Agent sessions | PostgreSQL | Shared database | ✅ Yes (persisted) |
| Cache/pub-sub | Redis | Shared database | ✅ Yes (persisted with `--appendonly yes`) |
| Audit logs | PostgreSQL | Shared database | ✅ Yes (persisted) |

**The `openclaw_data` volume is critical** — it stores OpenClaw's internal state, agent registrations, and configuration. Loss of this volume means losing OpenClaw settings.

---

### First Test Workflow

1. **Verify all services running**:
   ```bash
   docker-compose ps
   # Should show: postgres, redis, openclaw, household-api all running
   ```

2. **Access OpenClaw Web UI**:
   ```bash
   # Open browser to OpenClaw control panel
   http://localhost:8001
   # (exact path depends on OpenClaw version; typically /dashboard or /ui)
   ```

3. **Check OpenClaw health**:
   ```bash
   curl http://localhost:8001/health
   ```

4. **Check API health**:
   ```bash
   curl http://localhost:8000/health
   ```

5. **Test Home Assistant integration**:
   ```bash
   curl http://localhost:8000/integrations/home-assistant/entities
   ```

6. **Invoke an agent via OpenClaw** (syntax depends on OpenClaw version):
   ```bash
   # Example: Query OpenClaw for agents
   curl http://localhost:8001/agents
   ```

7. **Check audit logs**:
   ```bash
   docker-compose exec postgres psql -U household_ai -d household_ai -c "SELECT * FROM audit_logs LIMIT 10;"
   ```

8. **View container logs**:
   ```bash
   docker-compose logs -f openclaw
   docker-compose logs -f household-api
   ```

---

## Architecture

### Component Overview

```
Household Services (Docker Compose)
├─ OpenClaw (Agent Orchestrator)
│  ├─ Loads agents from /agents/
│  ├─ Loads skills from /skills/
│  ├─ Manages agent state
│  └─ API on port 8001
│
├─ 8 Agents (household-chief, home-automation, librarian, meal-planner, etc.)
│  └─ Read/write shared memory (/memory/)
│
├─ household-api (FastAPI Integration Gateway)
│  ├─ /integrations/home-assistant/* ─→ Home Assistant REST API
│  ├─ /integrations/google-calendar/* ─→ Google Calendar API
│  ├─ /integrations/gmail/* ─→ Gmail API
│  ├─ /integrations/docker/* ─→ Docker daemon
│  ├─ /integrations/library/* ─→ Kavita, Calibre-Web, Audiobookshelf
│  ├─ /integrations/grocery/* ─→ Grocy
│  ├─ /integrations/water/* ─→ Water usage API
│  └─ /integrations/vehicles/* ─→ Maintenance database
│
├─ Redis (Shared)
│  ├─ pub/sub for agent communication
│  ├─ Task queues
│  └─ Caching
│
├─ Postgres (Shared)
│  ├─ Audit logs (all actions)
│  ├─ Confirmations (user approvals)
│  ├─ Service state
│  ├─ Alerts
│  ├─ Agent sessions
│  └─ Rate limits
│
└─ /memory/ Volume (Shared)
   ├─ household/ (family profile, routines, safety rules)
   ├─ systems/ (HA config, docker hosts, network)
   ├─ library/ (library systems, reading preferences)
   ├─ food/ (pantry rules, leftover management)
   └─ vehicles/ (maintenance records)

Connection Flow:
User/OpenClaw CLI → OpenClaw REST API (port 8001)
                  ↓
           Agent processes request
                  ↓
           Agent invokes Skill via REST
                  ↓
           household-api routes to external service
                  ↓
           External system (HA, Google, Grocy, etc.)
```

External Services (lthome.us infrastructure)
  ├─ had.lthome.us (Home Assistant)
  ├─ comics.lthome.us (Kavita)
  ├─ books.lthome.us (Calibre-Web)
  ├─ audiobooks.lthome.us (Audiobookshelf)
  ├─ photos.lthome.us (Immich)
  ├─ music.lthome.us (Navidrome)
  ├─ grocery.lthome.us (Grocy)
  ├─ Google Calendar & Gmail APIs
  ├─ Docker hosts (health, logs, restart)
  └─ Water usage monitoring API
```

### Data Flow

1. **User Interaction** (via OpenClaw CLI/API):
   ```
   "Suggest a meal using what's in the pantry"
   → OpenClaw → meal-planner agent → meal-planning skill
   → household-api:/integrations/grocery/inventory
   → Grocy API → meal-planner formats response → OpenClaw → User
   ```

2. **Confirmation-Gated Action** (with CLI prompt):
   ```
   "Send an email reminder about vehicle maintenance"
   → OpenClaw → vehicle-maintenance agent → gmail-triage skill
   → household-api:/integrations/gmail/draft
   → [CLI PROMPT: "Send this email? (yes/no)"]
   → If yes: Gmail API → email sent; audit logged
   → If no: action cancelled; audit logged
   ```

3. **Scheduled Task** (cron-driven):
   ```
   Daily 8 AM → household-api:/scheduled/household-chief-summary
   → Redis pub/sub triggers household-chief agent
   → Agent invokes home-assistant, calendar, water-monitor skills
   → Compiles daily brief → Logs to Postgres → Returns to user
   ```

---

## Docker Deployment

### Containerized OpenClaw

OpenClaw runs as a Docker service alongside household-api, postgres, and redis. This provides a unified, self-contained deployment where all agents run within a single container orchestration.

**Key benefit**: OpenClaw is now part of your Docker stack — no separate installation needed. Simply run `docker-compose up` and all services (OpenClaw, API, database, cache) start together.

**Container Configuration**:

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| `openclaw` | `lantern-ai/openclaw:latest` (or custom) | 8001 | Agent orchestrator — manages agents, routes skills, provides web UI & API |
| `household-api` | Built from `./services/household-api/Dockerfile` | 8000 | Integration gateway — OpenClaw skills call these endpoints |
| `postgres` | `postgres:15-alpine` | 5432 | Shared database for audit logs, sessions, confirmations |
| `redis` | `redis:7-alpine` | 6379 | Shared pub/sub, caching, task queue |

**Shared Resources** (all services mount these):
- `/agents/` - Agent definitions (read-only in containers, writable on host)
- `/skills/` - Skill definitions (read-only in containers, writable on host)
- `/memory/` - Shared household knowledge (read-write for agents)
- `/config/` - Configuration files (permissions, confirmation policy, etc.)

**Persistent Volumes**:
- `postgres_data` — PostgreSQL database files (survives reboots)
- `redis_data` — Redis snapshots (survives reboots)
- `openclaw_data` — OpenClaw configuration (~/.openclaw/openclaw.json and internal state) (survives reboots)

### OpenClaw Initialization

First time you run the system:

```bash
docker-compose up -d

# Wait for all services to be healthy
docker-compose ps
# openclaw should show "healthy" after ~30 seconds

# Check OpenClaw logs to see agent discovery
docker-compose logs -f openclaw
# Should see: "Loaded X agents from /app/agents"
#            "Loaded X skills from /app/skills"
#            "API listening on 0.0.0.0:8001"
```

OpenClaw automatically:
1. Discovers agents from `./agents/` directory
2. Discovers skills from `./skills/` directory
3. Connects to PostgreSQL database
4. Connects to Redis
5. Initializes config file in persistent volume
6. Starts REST API on port 8001

No manual registration or configuration needed.

### Data Persistence & Container Reboots

All data persists across reboots:

```bash
# Stop all containers
docker-compose down

# All data is preserved in volumes:
# - openclaw_data (OpenClaw config)
# - postgres_data (Database)
# - redis_data (Cache)
# - ./agents/ ./skills/ ./memory/ ./config/ (Local filesystems)

# Restart — all data restored
docker-compose up -d

# OpenClaw config is intact, agents are re-discovered, database is unchanged
```

### Database Setup

OpenClaw and household-api share a single PostgreSQL instance:
- All services connect to `postgresql://household_ai:password@postgres:5432/household_ai`
- Database is initialized once on first startup
- Schema includes audit_logs, agent_sessions, confirmations, service_state, alerts, rate_limits tables
- All services use this shared database

### Custom OpenClaw Image

If you have a custom OpenClaw build or want to use a different image registry:

```bash
# In .env
OPENCLAW_IMAGE=my-registry/my-openclaw:custom-tag
OPENCLAW_LOG_LEVEL=DEBUG
```

Then restart:
```bash
docker-compose up -d openclaw
```

### Docker Compose Commands

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs (all services)
docker-compose logs -f

# View specific service logs
docker-compose logs -f openclaw
docker-compose logs -f household-api

# Stop services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v

# Rebuild images (after code changes)
docker-compose build --no-cache
docker-compose up -d
```

### Port Mapping

| Service | Internal Port | Host Port | Purpose |
|---------|---------------|-----------|---------|
| OpenClaw | 8001 | 8001 | Agent API |
| household-api | 8000 | 8000 | Integration API |
| PostgreSQL | 5432 | 5432 | Database |
| Redis | 6379 | 6379 | Cache/Pub-Sub |

Access locally:
- OpenClaw: http://localhost:8001
- API: http://localhost:8000
- Database: psql -h localhost -U household_ai
- Redis: redis-cli -h localhost

---

## Setup & Environment Variables

### .env Template

See `.env.example` for all required variables. Key sections:

```bash
# API Gateway
API_HOST=0.0.0.0
API_PORT=8000

# OpenClaw (Containerized)
OPENCLAW_IMAGE=lantern-ai/openclaw:latest  # Custom image or use default
OPENCLAW_LOG_LEVEL=INFO
OPENCLAW_BASE_URL=http://openclaw:8001  # Internal Docker network (or localhost:8001)
OPENCLAW_API_KEY=your_openclaw_api_key   # If authentication required

# Home Assistant
HOME_ASSISTANT_URL=http://had.lthome.us
HOME_ASSISTANT_TOKEN=your_ha_token

# Google APIs (Calendar, Gmail)
GOOGLE_APPLICATION_CREDENTIALS=/secrets/google-creds.json
GOOGLE_CALENDAR_ID=your_family_calendar_id
GOOGLE_GMAIL_ADDRESS=your_email@gmail.com

# OpenAI (LLM backend for agents)
OPENAI_API_KEY=sk-...

# External Service APIs
GROCY_API_URL=http://grocery.lthome.us
GROCY_API_KEY=your_grocy_key

WATER_API_URL=http://your-water-api-endpoint
WATER_API_KEY=your_water_key

# Docker hosts (for system admin)
DOCKER_HOST_1=unix:///var/run/docker.sock
DOCKER_HOST_2=tcp://docker-pi-01.lthome.us:2375

# Database
POSTGRES_USER=household_ai
POSTGRES_PASSWORD=your_secure_postgres_password
POSTGRES_DB=household_ai

REDIS_URL=redis://redis:6379

# Logging
LOG_LEVEL=INFO
AUDIT_LOG_ENABLED=true

# Mock/Debug
MOCK_INTEGRATIONS=false  # Set true for development without real API keys
```

---

## Agents

Agents are OpenClaw-orchestrated entities with roles, goals, available skills, and memory access.

### Viewing Registered Agents

Once OpenClaw is running, view all registered agents:

```bash
# Via REST API
curl http://localhost:8001/agents

# Via web UI
http://localhost:8001/dashboard
# (or similar, depending on OpenClaw version)
```

You should see 8 agents:
1. household-chief-of-staff
2. home-automation
3. librarian
4. meal-planner
5. sysadmin
6. family-calendar
7. water-monitor
8. vehicle-maintenance

### Adding a New Agent

OpenClaw **auto-discovers** agents from the `./agents/` directory. To add a new agent:

1. **Create agent directory**:
   ```bash
   mkdir agents/my-new-agent
   ```

2. **Create agent.yaml**:
   ```yaml
   name: my-new-agent
   role: "Brief role description"
   goals:
     - Goal 1
     - Goal 2
   available_skills:
     - skill_1
     - skill_2
   memory_paths:
     - memory/household/*
     - memory/systems/*
   allowed_actions:
     - query_home_assistant
     - read_calendar
   forbidden_actions:
     - unlock_doors
     - disable_security
   confirmation_required:
     - restarting_containers
     - sending_emails
   ```

3. **Create instructions.md**:
   - Detailed behavior guidelines
   - Safety rules and constraints
   - Daily/weekly routines (if applicable)
   - Escalation criteria

4. **Restart OpenClaw** to discover the new agent:
   ```bash
   docker-compose restart openclaw
   docker-compose logs -f openclaw
   # Should see: "Loaded my-new-agent from /app/agents/my-new-agent"
   ```

5. **Verify** via API:
   ```bash
   curl http://localhost:8001/agents | grep my-new-agent
   ```

---

## Skills

Skills are OpenClaw-invoked instructions that agents use to interact with external systems.

### Viewing Registered Skills

Once OpenClaw is running, view all registered skills:

```bash
# Via REST API
curl http://localhost:8001/skills

# Filter for specific skill
curl http://localhost:8001/skills | grep home-assistant
```

You should see 11 skills registered:
1. home-assistant
2. google-calendar
3. gmail-triage
4. docker-health
5. library-systems
6. grocery-inventory
7. meal-planning
8. water-usage-monitor
9. vehicle-maintenance
10. household-maintenance
11. family-knowledge-base

### Adding a New Skill

OpenClaw **auto-discovers** skills from the `./skills/` directory. To add a new skill:

1. **Create skill directory**:
   ```bash
   mkdir skills/my-new-skill
   ```

2. **Create SKILL.md** with required YAML frontmatter:
   ```yaml
   ---
   name: my-new-skill
   description: Brief description of what this skill does
   category: category_name
   risk_level: low|medium|high|critical
   requires_confirmation_for:
     - sending_emails
     - modifying_external_state
   allowed_tools:
     - home_assistant
     - external_api
   ---

   # My New Skill

   ## Purpose
   What this skill does.

   ## When to Use
   Specific use cases.

   ## When NOT to Use
   Situations to avoid.

   ## Required Context
   What agents need to know.

   ## Step-by-Step Behavior
   1. Step 1
   2. Step 2

   ## Safety Rules
   - Rule 1
   - Rule 2

   ## Example User Requests
   - Example 1
   - Example 2

   ## Example Responses
   - Response 1
   - Response 2

   ## Failure Handling
   What to do if errors occur.
   ```

3. **Restart OpenClaw** to discover the new skill:
   ```bash
   docker-compose restart openclaw
   docker-compose logs -f openclaw
   # Should see: "Loaded my-new-skill from /app/skills/my-new-skill"
   ```

4. **Verify** via API:
   ```bash
   curl http://localhost:8001/skills | grep my-new-skill
   ```

5. **Update agent instructions** to reference the new skill:
   ```bash
   # Edit agents/*/agent.yaml to add skill to available_skills list
   nano agents/my-agent/agent.yaml
   # Add my-new-skill to available_skills:
   #   - my-new-skill

   docker-compose restart openclaw
   ```

---

## Security Model

### Permissions

See `config/permissions.yaml` for the skill permission matrix. Each skill has:
- **read**: Can query external systems
- **write**: Can modify non-critical state
- **destructive**: Requires confirmation for database changes, service restarts, etc.

### Confirmation Policy

See `config/confirmation-policy.yaml`. The following actions **always** require CLI confirmation:
- Sending emails
- Modifying calendar events
- Restarting containers
- Changing Home Assistant device state (locks, security)
- Deleting or modifying records

### Audit Logging

See `config/audit-policy.yaml`. All actions are logged to Postgres:
- **what**: action name, parameters
- **who**: agent/skill invoking the action
- **when**: timestamp
- **result**: success/failure, confirmation status
- **context**: related memory files, affected entities

Retention: 90 days (configurable).

### Secret Management

- **No secrets in repository** — all credentials via `.env` (gitignored)
- `.env.example` shows template; copy and fill with real values
- Use a secrets manager (Vault, 1Password CLI) in production
- Credentials passed as environment variables to household-api container

### Safe vs. Unsafe Actions

**Safe** (no confirmation required):
- Query Home Assistant entity states
- Read calendar events
- Search library catalogs
- Query water usage history

**Unsafe** (confirmation required):
- Send emails
- Create/modify calendar events
- Restart Docker containers
- Change Home Assistant device state (locks, thermostats, security)
- Delete records
- Run shell commands on hosts

---

## Memory

Agents have read-write access to shared memory files. Memory is versioned markdown/YAML, easily edited by humans and queried by agents.

### Memory Organization

```
memory/
  household/
    family-profile.md       # Names, ages, preferences
    rooms.md                # Layout, occupants, automation groups
    routines.md             # Daily schedules, recurring tasks
    safety-rules.md         # Rules agents must follow
  systems/
    home-assistant.md       # Entity mappings, automations
    docker-hosts.md         # Host inventory, credentials
    network-map.md          # Internal network topology
    services.md             # Service URLs and API endpoints
  library/
    library-systems.md      # Kavita, Calibre-Web, Audiobookshelf endpoints
    reading-preferences.md  # Genres, authors, allowlist/denylist
  food/
    pantry-rules.md         # Dietary preferences, allergies, expiration handling
    leftover-rules.md       # Conventions for storing/using leftovers
  vehicles/
    2013-ford-f150.md       # Maintenance schedule, last service dates
    1991-jeep-wrangler.md   # (same)
    2008-acura-rdx.md       # (same)
  audit/
    (generated logs, never manually edited)
```

### Editing Memory

1. **Manual edits** (human-friendly):
   ```bash
   nano memory/household/family-profile.md
   ```

2. **Agent writes** (skill-initiated):
   - Agents can update memory files (e.g., meal-planner adds new recipe preferences)
   - All writes are audit-logged
   - Conflicts resolved by timestamp (last-write-wins)

3. **Version control**:
   - Commit memory/ to git for history
   - Memory/ is a source of truth; backup regularly

---

## Docker Compose

Services included:

- **household-api** (FastAPI, port 8000)
- **redis** (port 6379, internal)
- **postgres** (port 5432, internal)

Health checks ensure all services start correctly.

### Start All Services

```bash
docker-compose up -d
```

### View Logs

```bash
docker-compose logs -f household-api
docker-compose logs -f redis
docker-compose logs -f postgres
```

### Stop All Services

```bash
docker-compose down
```

### Reset Database

```bash
docker-compose down -v
docker-compose up -d
```

---

## Troubleshooting

### OpenClaw Not Starting

**Error**: OpenClaw container exits or shows unhealthy status

**Check**:
```bash
docker-compose logs openclaw
```

**Common causes**:
1. **Agent/skill discovery error** — malformed YAML in agent.yaml or SKILL.md
   ```bash
   # Validate agent YAML
   cat agents/household-chief-of-staff/agent.yaml | python -m yaml
   ```
2. **Database connection failed** — postgres not ready or credentials wrong
   ```bash
   # Check postgres health
   docker-compose logs postgres
   docker-compose exec postgres psql -U household_ai -c "SELECT 1;"
   ```
3. **Redis connection failed** — redis not running
   ```bash
   docker-compose logs redis
   docker-compose exec redis redis-cli ping
   ```
4. **Missing env variables** — OPENCLAW_* variables not set
   ```bash
   docker-compose exec openclaw env | grep OPENCLAW
   ```

### Agents Not Appearing in OpenClaw

**Error**: OpenClaw starts but agents are not visible via `/agents` endpoint or web UI

**Check**:
```bash
# View OpenClaw discovery logs
docker-compose logs openclaw | grep -i "agent\|skill\|discover"

# Verify agent files exist
ls -la agents/
ls -la agents/household-chief-of-staff/

# Verify agent.yaml syntax
cat agents/household-chief-of-staff/agent.yaml
```

**Common causes**:
1. **agent.yaml missing or malformed** — agent.yaml must exist and be valid YAML
2. **Wrong directory structure** — should be `agents/[agent-name]/agent.yaml`
3. **OpenClaw config restricts agents** — check openclaw.json (in openclaw_data volume)
4. **Volume mounts wrong** — verify docker-compose.yml mounts `./agents:/app/agents:ro`

**Fix**:
```bash
# Verify all agents have required files
for agent_dir in agents/*/; do
  if [ ! -f "$agent_dir/agent.yaml" ]; then
    echo "MISSING: $agent_dir/agent.yaml"
  fi
  if [ ! -f "$agent_dir/instructions.md" ]; then
    echo "MISSING: $agent_dir/instructions.md"
  fi
done

# Restart OpenClaw to re-discover
docker-compose restart openclaw
docker-compose logs -f openclaw
```

### OpenClaw Config Lost After Restart

**Error**: OpenClaw settings, channel configs, or customizations are gone after `docker-compose restart`

**This should NOT happen** — the `openclaw_data` volume persists config.

**Check**:
```bash
# Verify volume exists and has data
docker volume ls | grep openclaw
docker volume inspect household-ai-agent_openclaw_data

# Check if config file exists in volume
docker-compose exec openclaw ls -la /root/.openclaw/
docker-compose exec openclaw cat /root/.openclaw/openclaw.json
```

**If config is lost**:
1. Check if `openclaw_data` volume was accidentally deleted
2. Verify docker-compose.yml has the volume defined and mounted
3. Ensure you're not using `docker-compose down -v` (which removes volumes)

**Prevent data loss**:
```bash
# Always use:
docker-compose down          # Stops containers, preserves volumes

# Never use:
docker-compose down -v       # Stops containers AND removes volumes
```

### API Not Starting

**Error**: `Connection refused` when trying to curl `/health`

**Check**:
```bash
docker-compose logs household-api
```

**Common causes**:
- Missing `.env` file or required variables
- Port 8000 already in use
- Postgres/Redis not ready (check logs)

### External Service Integration Failing

**Error**: `Unauthorized` or `Connection refused` to Home Assistant, calendar, etc.

**Check**:
1. Verify `.env` variables are correct
2. Test connectivity manually:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" http://had.lthome.us/api/states
   ```
3. Check firewall rules for internal network access

### Audit Logs Not Recording

**Error**: No entries in `audit_logs` table

**Check**:
```bash
docker-compose exec postgres psql -U household_ai -d household_ai -c "\dt"
```

**Common causes**:
- Postgres not initialized; run migrations:
  ```bash
  docker-compose exec household-api python -m app.db.init_db
  ```

### OpenClaw CLI Not Working

**Error**: `openclaw` CLI commands fail or can't connect to API

**Check**:
1. Verify OpenClaw API is running on port 8001
2. Install OpenClaw CLI locally (if needed):
   ```bash
   pip install openclaw-cli
   ```
3. Point CLI to running instance:
   ```bash
   openclaw --api-url http://localhost:8001 agents list
   ```

---

## Development

### Local Testing Without External APIs

Set `MOCK_INTEGRATIONS=true` in `.env` to use mock data:
```bash
MOCK_INTEGRATIONS=true
docker-compose up -d
```

API will return plausible mock responses for all integrations, allowing testing without real credentials.

### Running Tests

```bash
docker-compose exec household-api pytest -v
```

### Adding a New Integration Endpoint

1. Create router in `services/household-api/app/routers/integrations.py`
2. Add Pydantic models in `services/household-api/app/models/`
3. Implement endpoint with proper error handling and logging
4. Update `.env.example` with new required variables
5. Document in README

---

## FAQ

**Q: What is OpenClaw and what does it do in this project?**
A: OpenClaw is a multi-channel AI agent orchestrator. In this project, it:
- Loads and manages 8 AI agents (each with different roles: home automation, meal planning, etc.)
- Routes agent requests to skills (tools) that call the household-api
- Manages agent sessions, context, and state
- Provides a web UI, REST API, and CLI for interacting with agents
- Handles agent-to-agent coordination through shared memory
See the "OpenClaw Setup & Configuration" section above for details.

**Q: Is OpenClaw containerized? Do I need to install it separately?**
A: No and no. OpenClaw runs in Docker as part of this project. Simply run `docker-compose up -d` and OpenClaw starts automatically on port 8001. No separate installation needed.

**Q: How do agents talk to external services?**
A: Agents invoke skills, which call household-api endpoints. Example flow:
```
Agent (in OpenClaw) → Skill (reads agent's instructions)
  → household-api:/integrations/home-assistant/entities
  → Home Assistant REST API
  → Result returned to agent
```

**Q: Can agents talk to each other?**
A: Not directly in the MVP. Agents communicate through:
- Shared memory files (read-write)
- Redis pub/sub (if implemented)
- Sequential invocation via OpenClaw

Agent-to-agent chaining can be added in a later phase.

**Q: How do I invoke an agent?**
A: Three ways:
1. **Web UI** (browser): http://localhost:8001/dashboard (or similar, depends on OpenClaw version)
2. **REST API** (curl):
   ```bash
   curl -X POST http://localhost:8001/agents/household-chief-of-staff/invoke \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Summarize household status"}'
   ```
3. **CLI** (if OpenClaw CLI is installed locally):
   ```bash
   openclaw agents invoke household-chief-of-staff "Summarize household status"
   ```

**Q: What if an action requires approval but the user is away?**
A: Actions requiring confirmation will block indefinitely until approved/denied via:
- CLI prompt (if running in terminal)
- Web UI confirmation dialog (if using OpenClaw web UI)
- API response (if submitting via REST)
Recommendation: Store actions in Postgres with expiration, allow remote approval via mobile app (future enhancement).

**Q: Can I add a new external service (e.g., Immich photo search)?**
A: Yes. Add a new `/integrations/immich` endpoint in household-api, create a corresponding skill, and reference it in agent instructions. See "Adding a New Skill" above.

**Q: How do I scale this to multiple machines?**
A: Current design is single-machine. For multi-machine scaling, add:
- Service discovery (Consul, DNS)
- Load balancing
- Distributed Redis
- Shared filesystem for agents/skills/memory
This is out of scope for MVP but can be added in Phase 10.

**Q: Will my OpenClaw config survive container reboots?**
A: Yes. OpenClaw config is stored in the `openclaw_data` persistent Docker volume, mounted at `/root/.openclaw/`. See "Data Persistence" section for details.

**Q: What if I accidentally delete the `openclaw_data` volume?**
A: OpenClaw will reinitialize on next restart. Agents and skills are re-discovered from `./agents/` and `./skills/` directories (committed to git), so no data is lost. However, any OpenClaw-specific configuration (channel registrations, etc.) will be reset to defaults.

**Q: How do I backup agent/skill/memory data?**
A: All persistent data is in version-controlled directories or Docker volumes:
- **Version-controlled**: `./agents/`, `./skills/`, `./memory/`, `./config/` (commit to git)
- **Database**: `postgres_data` volume (backup via `pg_dump` or volume snapshots)
- **OpenClaw config**: `openclaw_data` volume (backup via Docker volume inspection)

Backup strategy:
```bash
# Backup database
docker-compose exec postgres pg_dump -U household_ai household_ai > backup.sql

# Backup volumes (inspect and copy)
docker run --rm -v household-ai-agent_openclaw_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/openclaw-backup.tar.gz /data

# Backup git-tracked data
git commit -am "Backup state"
git push origin main
```

---

## License

See LICENSE file.

## Support & Contributions

For issues or feature requests, see GitHub issues.
