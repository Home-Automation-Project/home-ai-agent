# Household AI with Traefik (Docker Compose)

This is an alternative Docker Compose setup that includes Traefik reverse proxy with SSL/TLS support for production deployments.

## Overview

- **Traefik** (v2.10) — Reverse proxy, load balancer, automatic HTTPS
- **OpenClaw** — Accessible at `https://api.lthome.us`
- **Household API** — Accessible at `https://api-ai.lthome.us`
- **Traefik Dashboard** — Accessible at `https://traefik-ai.lthome.us`
- **Self-Signed Certificates** — Auto-generated for local/private deployment
- **PostgreSQL, Redis** — Same shared infrastructure as base deployment

## Quick Start

### 1. Generate Self-Signed SSL Certificates

**On macOS/Linux**:
```bash
chmod +x setup-ssl-certs.sh
./setup-ssl-certs.sh
```

**On Windows (PowerShell)**:
```powershell
.\setup-ssl-certs.ps1
```

This creates certificates in `./traefik/certs/` valid for 365 days covering:
- lthome.us (wildcard: *.lthome.us)
- api.lthome.us
- api-ai.lthome.us
- traefik-ai.lthome.us

### 2. Configure DNS or Hosts File

For local testing, add entries to your hosts file:

**Linux/macOS** (`/etc/hosts`):
```
127.0.0.1   lthome.us
127.0.0.1   api.lthome.us
127.0.0.1   api-ai.lthome.us
127.0.0.1   traefik-ai.lthome.us
```

**Windows** (`C:\Windows\System32\drivers\etc\hosts`):
```
127.0.0.1   lthome.us
127.0.0.1   api.lthome.us
127.0.0.1   api-ai.lthome.us
127.0.0.1   traefik-ai.lthome.us
```

Or, if your server is on a different machine:
```
192.168.1.100   api.lthome.us
192.168.1.100   api-ai.lthome.us
192.168.1.100   traefik-ai.lthome.us
```

### 3. Set Environment Variables

```bash
cp .env.example .env
# Edit .env with your credentials (same as base docker-compose)
```

### 4. Start Services with Traefik

```bash
# Use the Traefik-enabled compose file
docker-compose -f docker-compose.traefik.yml up -d

# Wait for services to be healthy
docker-compose -f docker-compose.traefik.yml ps

# View logs
docker-compose -f docker-compose.traefik.yml logs -f
```

### 5. Access Services via HTTPS

```bash
# Traefik Dashboard (monitor services and routing)
https://traefik-ai.lthome.us

# OpenClaw API
https://api.lthome.us
curl https://api.lthome.us/health

# Household API
https://api-ai.lthome.us
curl https://api-ai.lthome.us/health
```

**Note**: Self-signed certificate warnings are normal. Your browser will show a security warning; choose "Advanced" → "Proceed anyway" or add the certificate to your trusted store (see below).

## Architecture

```
Internet/LAN
    ↓
Traefik (Port 80, 443)
  ├─ HTTP → Redirect to HTTPS
  ├─ HTTPS → Route by domain
  │
  ├─ api.lthome.us → OpenClaw (8001)
  ├─ api-ai.lthome.us → Household API (8000)
  └─ traefik-ai.lthome.us → Traefik Dashboard (8080)
    ↓
Internal Docker Network (172.25.0.0/16)
  ├─ OpenClaw
  ├─ Household API
  ├─ PostgreSQL
  └─ Redis
```

## SSL/TLS Configuration

### Self-Signed Certificates

The setup script generates:
- `traefik/certs/server.crt` — Public certificate
- `traefik/certs/server.key` — Private key
- `traefik/certs/server.pem` — Combined PEM format

These certificates are **self-signed** and valid for 365 days. They cover:
- All subdomains: `*.lthome.us`
- All specific domains

### Using Let's Encrypt (Production)

To use real Let's Encrypt certificates instead:

1. **Edit `traefik/traefik.yml`**:
   ```yaml
   certificatesResolvers:
     letsencrypt:
       acme:
         email: "your-email@example.com"
         storage: /acme.json
         caServer: "https://acme-v02.api.letsencrypt.org/directory"  # Remove staging
         httpChallenge:
           entryPoint: web
   ```

2. **Update labels in `docker-compose.traefik.yml`**:
   ```yaml
   - "traefik.http.routers.openclaw.tls.certresolver=letsencrypt"
   - "traefik.http.routers.household-api.tls.certresolver=letsencrypt"
   - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
   ```

3. **Ensure port 80 is accessible** from the internet (for HTTP-01 challenge)

4. **Restart Traefik**:
   ```bash
   docker-compose -f docker-compose.traefik.yml restart traefik
   ```

## Trusting Self-Signed Certificates

### macOS

```bash
# Import certificate into system keychain
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./traefik/certs/server.crt

# Or open Keychain Access and drag the cert into login keychain
open -a Keychain\ Access ./traefik/certs/server.crt
```

### Linux (Ubuntu/Debian)

```bash
# Copy certificate to trusted store
sudo cp ./traefik/certs/server.crt /usr/local/share/ca-certificates/lthome.crt
sudo update-ca-certificates

# Or for Firefox (NSS):
certutil -d sql:$HOME/.mozilla/firefox/PROFILE.default -A -t "TC,," -n "lthome.us" -i ./traefik/certs/server.crt
```

### Windows

1. **Open Certificate Manager** (certmgr.msc)
2. **Navigate to** Trusted Root Certification Authorities → Certificates
3. **Right-click** → All Tasks → Import
4. **Select** `traefik/certs/server.crt`
5. **Click Next** → Next → Finish

Or via PowerShell:
```powershell
Import-Certificate -FilePath ".\traefik\certs\server.crt" -CertStoreLocation "Cert:\LocalMachine\Root"
```

## Traefik Dashboard

Access the Traefik dashboard at `https://traefik-ai.lthome.us:8080` (or without port if using HTTPS).

**Features**:
- View all routers and services
- Monitor health checks
- See active routes and rules
- View metrics and logs
- Real-time service status

**Note**: The dashboard is insecure (no authentication by default). For production, add middleware authentication:
```yaml
labels:
  - "traefik.http.routers.traefik.middlewares=auth@file"
  - "traefik.http.middlewares.auth.basicauth.users=user:hashed_password"
```

## Managing Services

### View Logs

```bash
# All services
docker-compose -f docker-compose.traefik.yml logs -f

# Specific service
docker-compose -f docker-compose.traefik.yml logs -f traefik
docker-compose -f docker-compose.traefik.yml logs -f openclaw
docker-compose -f docker-compose.traefik.yml logs -f household-api
```

### Stop Services

```bash
docker-compose -f docker-compose.traefik.yml down
```

### Restart Services

```bash
docker-compose -f docker-compose.traefik.yml restart traefik
docker-compose -f docker-compose.traefik.yml restart openclaw
docker-compose -f docker-compose.traefik.yml restart household-api
```

### View Service Status

```bash
docker-compose -f docker-compose.traefik.yml ps
```

## Troubleshooting

### Certificate Warnings in Browser

**Expected behavior**: Self-signed certificates trigger browser warnings. This is normal and secure in private networks.

**Solutions**:
1. Click "Advanced" → "Proceed anyway" in browser
2. Trust the certificate in your OS (see above)
3. Switch to Let's Encrypt for production

### Cannot Reach Services (Connection Refused)

1. **Verify Traefik is running**:
   ```bash
   docker-compose -f docker-compose.traefik.yml ps traefik
   # Should show "Up" and "healthy"
   ```

2. **Check Traefik logs**:
   ```bash
   docker-compose -f docker-compose.traefik.yml logs traefik | tail -50
   ```

3. **Verify hosts file entries**:
   ```bash
   ping api.lthome.us
   # Should resolve to your server IP
   ```

4. **Check DNS/firewall**:
   ```bash
   curl -v https://api.lthome.us
   # Should show SSL handshake and certificate details
   ```

### Services Not Appearing in Traefik Dashboard

1. **Verify labels are set** on services in docker-compose.traefik.yml
2. **Check service health**:
   ```bash
   docker-compose -f docker-compose.traefik.yml ps
   ```
3. **View Traefik discovery logs**:
   ```bash
   docker-compose -f docker-compose.traefik.yml logs traefik | grep -i "route\|service"
   ```

### SSL/TLS Errors

1. **Verify certificates exist**:
   ```bash
   ls -la ./traefik/certs/
   ```

2. **Check certificate validity**:
   ```bash
   openssl x509 -in ./traefik/certs/server.crt -text -noout
   ```

3. **Regenerate certificates**:
   ```bash
   rm -rf ./traefik/certs/*
   ./setup-ssl-certs.sh  # or .ps1 on Windows
   docker-compose -f docker-compose.traefik.yml restart traefik
   ```

## Performance & Security Notes

### Performance

- **Compression**: All routes use gzip compression (see labels)
- **Health checks**: Services health-checked every 30s
- **Load balancing**: Traefik automatically balances across instances

### Security

- **HTTPS enforced**: HTTP automatically redirects to HTTPS
- **TLS 1.2+**: Only modern TLS versions allowed
- **Strong ciphers**: Configured for modern security standards
- **Self-signed only**: For private networks; use Let's Encrypt for public

### Production Considerations

1. **Use real certificates** (Let's Encrypt or CA-signed)
2. **Add authentication** to Traefik dashboard
3. **Use stronger passwords** for all services
4. **Enable firewall rules** to restrict access
5. **Regular backups** of `./memory/`, `postgres_data`, `redis_data`, `openclaw_data`
6. **Monitor logs** for errors and unauthorized access

## Comparison: Base vs Traefik

| Feature | docker-compose.yml | docker-compose.traefik.yml |
|---------|-------------------|---------------------------|
| HTTP only | ✅ Yes | ❌ No (HTTPS only) |
| HTTPS/SSL | ❌ No | ✅ Yes |
| Reverse proxy | ❌ No | ✅ Yes (Traefik) |
| Domain routing | ❌ No | ✅ Yes |
| Dashboard | ❌ No | ✅ Yes (traefik-ai.lthome.us) |
| Certificate management | Manual | Automatic |
| Complexity | Simple | Medium |
| Production-ready | ⚠️ For LAN only | ✅ Yes |

## Differences from Base Compose File

1. **Traefik service added** — Reverse proxy and load balancer
2. **Service labels added** — Route configuration via Docker labels
3. **Port changes**:
   - OpenClaw: Still 8001 internally, but exposed via Traefik on 443
   - API: Still 8000 internally, but exposed via Traefik on 443
   - Traefik dashboard: 8080 (accessible via 443 with HTTPS)
4. **Volume added**: `traefik_acme` for certificate storage
5. **Configuration files**: `traefik/traefik.yml` for static config
6. **No direct port exposure** (except 80, 443, 8080 for Traefik)

## Next Steps

1. ✅ Generate certificates: `./setup-ssl-certs.sh`
2. ✅ Configure hosts file or DNS
3. ✅ Copy `.env.example` to `.env` and fill in credentials
4. ✅ Start services: `docker-compose -f docker-compose.traefik.yml up -d`
5. ✅ Verify health: `docker-compose -f docker-compose.traefik.yml ps`
6. ✅ Trust certificate in your OS
7. ✅ Access services via HTTPS

For detailed setup, see the main [README.md](../README.md).
