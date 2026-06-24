# traefik-setup.ps1
# Household AI with Traefik - Quick Start Guide (Windows PowerShell)

Write-Host "🏠 Household AI with Traefik - Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Generate SSL certificates
Write-Host "📜 Step 1: Generating SSL Certificates..." -ForegroundColor Yellow
if (-not (Test-Path ".\traefik\certs\server.key")) {
    if (Test-Path ".\setup-ssl-certs.ps1") {
        Write-Host "Generating certificates..." -ForegroundColor Green
        & ".\setup-ssl-certs.ps1"
    }
    else {
        Write-Host "⚠️  setup-ssl-certs.ps1 not found" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "✅ SSL certificates already exist" -ForegroundColor Green
}
Write-Host ""

# Step 2: Check for .env file
Write-Host "🔐 Step 2: Environment Configuration..." -ForegroundColor Yellow
if (-not (Test-Path ".\.env")) {
    if (Test-Path ".\.env.traefik.example") {
        Copy-Item ".\.env.traefik.example" ".\.env"
        Write-Host "📝 Created .env from .env.traefik.example" -ForegroundColor Green
        Write-Host "⚠️  IMPORTANT: Edit .env with your credentials before starting!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Required variables to configure:" -ForegroundColor Yellow
        Write-Host "  - OPENAI_API_KEY (or set MOCK_INTEGRATIONS=true)" -ForegroundColor Cyan
        Write-Host "  - HOME_ASSISTANT_TOKEN" -ForegroundColor Cyan
        Write-Host "  - POSTGRES_PASSWORD" -ForegroundColor Cyan
        Write-Host "  - Other service credentials..." -ForegroundColor Cyan
        Write-Host ""
        exit 1
    }
    else {
        Write-Host "⚠️  .env.traefik.example not found" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "✅ .env file exists" -ForegroundColor Green
}
Write-Host ""

# Step 3: Configure hosts file
Write-Host "🌐 Step 3: Hosts File Configuration..." -ForegroundColor Yellow
$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$hostsEntries = @(
    "127.0.0.1   api.lthome.us",
    "127.0.0.1   api-ai.lthome.us",
    "127.0.0.1   traefik-ai.lthome.us"
)

Write-Host "Add these entries to your hosts file ($hostsPath):" -ForegroundColor Cyan
Write-Host ""
foreach ($entry in $hostsEntries) {
    Write-Host "  $entry" -ForegroundColor Cyan
}
Write-Host ""

# Check if entries exist
if (Test-Path $hostsPath) {
    $hostsContent = Get-Content $hostsPath
    $allFound = $true
    foreach ($entry in $hostsEntries) {
        if ($hostsContent -notmatch [regex]::Escape($entry)) {
            $allFound = $false
            break
        }
    }
    
    if ($allFound) {
        Write-Host "✅ Hosts file entries already configured" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Some hosts file entries are missing. Add them manually." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "To edit hosts file:" -ForegroundColor Yellow
        Write-Host "  1. Open Notepad as Administrator" -ForegroundColor Cyan
        Write-Host "  2. File → Open → $hostsPath" -ForegroundColor Cyan
        Write-Host "  3. Add the entries above" -ForegroundColor Cyan
        Write-Host "  4. Save and close" -ForegroundColor Cyan
    }
}
Write-Host ""

# Step 4: Start services
Write-Host "🚀 Step 4: Starting Services..." -ForegroundColor Yellow
Write-Host "Run the following command in PowerShell:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  docker-compose -f docker-compose.traefik.yml up -d" -ForegroundColor Green
Write-Host ""
Write-Host "Then check status with:" -ForegroundColor Cyan
Write-Host "  docker-compose -f docker-compose.traefik.yml ps" -ForegroundColor Green
Write-Host ""

# Step 5: Access services
Write-Host "🔗 Step 5: Access Services" -ForegroundColor Yellow
Write-Host "Once all services are healthy, access them at:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  🎛️  Traefik Dashboard: https://traefik-ai.lthome.us" -ForegroundColor Green
Write-Host "  🤖 OpenClaw API: https://api.lthome.us" -ForegroundColor Green
Write-Host "  🏠 Household API: https://api-ai.lthome.us" -ForegroundColor Green
Write-Host ""
Write-Host "Note: You'll see SSL certificate warnings (self-signed). This is normal." -ForegroundColor Yellow
Write-Host "Trust the certificate in your OS to remove warnings (see traefik/README.md)." -ForegroundColor Yellow
Write-Host ""

Write-Host "✅ Setup complete! Follow the steps above to start the system." -ForegroundColor Green
