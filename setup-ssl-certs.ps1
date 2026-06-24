# setup-ssl-certs.ps1
# Generates self-signed SSL certificates for Traefik and household AI services
# Windows/PowerShell version

param(
    [int]$DaysValid = 365
)

$CertDir = ".\traefik\certs"
$Domains = @("lthome.us", "api.lthome.us", "api-ai.lthome.us", "traefik-ai.lthome.us")
$CommonName = "lthome.us"

Write-Host "Creating certificate directory..."
New-Item -ItemType Directory -Path $CertDir -Force | Out-Null

Write-Host "Generating self-signed certificate for: $($Domains -join ', ')"
Write-Host ""

# Build SAN extension string
$SANString = "DNS:lthome.us,DNS:api.lthome.us,DNS:api-ai.lthome.us,DNS:traefik-ai.lthome.us,DNS:*.lthome.us"

# Create certificate using PowerShell
$CertPath = Join-Path $CertDir "server.crt"
$KeyPath = Join-Path $CertDir "server.key"

# Generate self-signed certificate
$Cert = New-SelfSignedCertificate `
    -CertStoreLocation "Cert:\LocalMachine\My" `
    -DnsName $Domains `
    -FriendlyName "Household AI Self-Signed Certificate" `
    -NotAfter (Get-Date).AddDays($DaysValid) `
    -KeyExportPolicy Exportable `
    -KeyAlgorithm RSA `
    -KeyLength 2048 `
    -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider v1.0"

Write-Host "Certificate generated with thumbprint: $($Cert.Thumbprint)"
Write-Host ""

# Export private key
$PvtKey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($Cert)
$PvtKeyBytes = $PvtKey.ExportPkcs8PrivateKey()
[System.IO.File]::WriteAllBytes($KeyPath, $PvtKeyBytes)

# Export certificate
[System.IO.File]::WriteAllBytes($CertPath, $Cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))

# Export as PEM (requires conversion)
$CertBase64 = [Convert]::ToBase64String($Cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert), [System.Base64FormattingOptions]::InsertLineBreaks)
$CertPEM = "-----BEGIN CERTIFICATE-----`n$CertBase64`n-----END CERTIFICATE-----"

$KeyBase64 = [Convert]::ToBase64String($PvtKeyBytes, [System.Base64FormattingOptions]::InsertLineBreaks)
$KeyPEM = "-----BEGIN PRIVATE KEY-----`n$KeyBase64`n-----END PRIVATE KEY-----"

# Write PEM files
$CertPemPath = Join-Path $CertDir "server.pem"
$CertPemOnlyPath = Join-Path $CertDir "server-cert.pem"
$KeyPemPath = Join-Path $CertDir "server-key.pem"

Set-Content -Path $CertPemOnlyPath -Value $CertPEM -Encoding UTF8
Set-Content -Path $KeyPemPath -Value $KeyPEM -Encoding UTF8
Set-Content -Path $CertPemPath -Value "$CertPEM`n$KeyPEM" -Encoding UTF8

Write-Host "✅ Self-signed certificates generated successfully!"
Write-Host ""
Write-Host "Certificate files:"
Write-Host "  Certificate (DER): $CertPath"
Write-Host "  Certificate (PEM): $CertPemOnlyPath"
Write-Host "  Private Key (PEM): $KeyPemPath"
Write-Host "  Combined PEM: $CertPemPath"
Write-Host "  Valid for: $DaysValid days"
Write-Host ""
Write-Host "Domains covered:"
foreach ($domain in $Domains) {
    Write-Host "  - $domain"
}
Write-Host ""
Write-Host "To trust this certificate in Windows:"
Write-Host "  1. Copy $CertPath to your desired location"
Write-Host "  2. Right-click the certificate and select 'Install Certificate'"
Write-Host "  3. Choose 'Local Machine' and 'Trusted Root Certification Authorities'"
Write-Host ""
Write-Host "Certificate details:"
Write-Host "  Thumbprint: $($Cert.Thumbprint)"
Write-Host "  Subject: $($Cert.Subject)"
Write-Host "  Issuer: $($Cert.Issuer)"
Write-Host "  Valid From: $($Cert.NotBefore)"
Write-Host "  Valid Until: $($Cert.NotAfter)"
