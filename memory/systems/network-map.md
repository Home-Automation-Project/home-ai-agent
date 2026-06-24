# Network Topology Map

## IP Address Scheme

### Home Network
- **Network**: 192.168.1.0/24
- **Gateway**: 192.168.1.1
- **DNS**: 192.168.1.1 (router) or [configured DNS]
- **DHCP range**: 192.168.1.100 - 192.168.1.254
- **Static IP range**: 192.168.1.10 - 192.168.1.99

### Docker Internal Network
- **Network**: 172.25.0.0/16
- **Gateway**: 172.25.0.1
- **Purpose**: Service-to-service communication
- **External access**: Only via mapped ports

## Devices and Services

### Networking Hardware
- **Router**: [Model and IP]
  - IP: 192.168.1.1
  - WiFi: [SSID and band]
  
- **Switch** (if separate): [Model]
  - IP: [IP address]
  - VLAN configuration: [If applicable]

### Network-Attached Devices

#### DNS/DHCP
- **Service**: [dnsmasq, pihole, or router-based]
- **IP**: 192.168.1.1 (or dedicated)
- **Responds to**: *.lthome.us

#### Primary Server
- **Hostname**: [hostname]
- **IP**: 192.168.1.[X]
- **MAC**: [MAC address]
- **Services**: Docker (household-ai)
- **Uptime**: [Expected uptime]

#### Raspberry Pi 1
- **Hostname**: docker-pi-01
- **IP**: 192.168.1.[X]
- **MAC**: [MAC address]
- **Services**: [Services running]

#### Raspberry Pi 2
- **Hostname**: docker-pi-02
- **IP**: 192.168.1.[X]
- **MAC**: [MAC address]
- **Services**: [Services running]

#### Home Assistant Server
- **Hostname**: had
- **IP**: 192.168.1.[X]
- **MAC**: [MAC address]
- **Service**: Home Assistant
- **Access**: had.lthome.us:8123

#### Grocy (Grocery Management)
- **Hostname**: grocery
- **IP**: 192.168.1.[X]
- **Service**: Grocy
- **Access**: grocery.lthome.us

#### Library Servers
- **Kavita** (Comics)
  - Hostname: comics
  - IP: 192.168.1.[X]
  - Access: comics.lthome.us

- **Calibre-Web** (Books)
  - Hostname: books
  - IP: 192.168.1.[X]
  - Access: books.lthome.us

- **Audiobookshelf** (Audiobooks)
  - Hostname: audiobooks
  - IP: 192.168.1.[X]
  - Access: audiobooks.lthome.us

#### Media Services
- **Immich** (Photos)
  - Hostname: photos
  - IP: 192.168.1.[X]
  - Access: photos.lthome.us

- **Navidrome** (Music)
  - Hostname: music
  - IP: 192.168.1.[X]
  - Access: music.lthome.us

### IoT Devices

#### Hubs & Coordinators
- **Aqara Hub**: 192.168.1.[X] (water leak monitoring)
- **Zigbee Coordinator** (if separate): 192.168.1.[X]
- **Z-Wave Stick**: [Connected to Home Assistant server]

#### Smart Speakers
- **Alexa devices**: [Locations and models]
  - Living room: [Model]
  - Bedroom: [Model]
  - Kitchen: [Model]

#### Smart Locks
- **Front door**: [Model and IP/Zigbee/Z-Wave]
- **Back door**: [Model]
- **Garage side door**: [Model]

#### Smart Switches & Lights
- **[Locations and types]**

#### Smart Plugs
- **Coffee maker**: [Model]
- **[Other devices]**

#### Sensors
- **Water meter**: [Model]
- **Motion sensors**: [Locations]
- **Door/Window contacts**: [Locations]
- **Thermostats**: [Model and location]

#### Garden/Outdoor
- **Irrigation controller**: [Model]
- **Smart hose**: [Model]
- **Outdoor lights**: [Model]
- **B-Hyve controller**: [IP/connection]

#### Monitoring
- **Meross garage door opener**: [IP]
- **Emporia Vue energy monitor**: [IP]
- **Roborock vacuum**: [Model and connectivity]

### Wireless Networks
- **Home WiFi SSID**: [SSID]
  - Band: 2.4 GHz / 5 GHz dual band
  - Channel: [Current channel]
  - Strength areas**: [Coverage map]
  
- **Guest WiFi SSID**: [SSID if separate]
  - Purpose: Guest access, IoT isolation
  - Password policy: [Change frequency]

## DNS Configuration

### Local DNS (lthome.us domain)
- **Resolver**: [dnsmasq / pihole / etc.]
- **Primary DNS**: 192.168.1.1

### DNS Records
```
had.lthome.us          -> 192.168.1.X
comics.lthome.us       -> 192.168.1.X
books.lthome.us        -> 192.168.1.X
audiobooks.lthome.us   -> 192.168.1.X
photos.lthome.us       -> 192.168.1.X
music.lthome.us        -> 192.168.1.X
grocery.lthome.us      -> 192.168.1.X
```

## Firewall Rules

### Inbound (to home network)
- SSH: [Restricted IPs or disabled for security]
- HTTP/HTTPS: [From [allowed external IPs or disabled]
- [Other allowed ports]

### Outbound
- All outbound allowed by default
- [Any restrictions]

### Internal (Docker)
- household-api to Redis: Allowed (172.25.0.0/16)
- household-api to Postgres: Allowed (172.25.0.0/16)
- All to all outbound to external: Allowed

## VPN / Remote Access

### VPN Setup
- **Type**: [OpenVPN / Tailscale / etc.]
- **Server IP**: [VPN server IP]
- **Clients**: [List of authorized devices]
- **Purpose**: Remote access to household systems

### Port Forwarding
- **Enabled**: [Yes/No]
- **Ports forwarded**: [List if any]

## Bandwidth Allocation

### QoS Settings
- **IoT devices**: [Low priority]
- **Video streaming**: [Medium priority]
- **Streaming services**: [High priority if applicable]
- **Household-api**: [High priority]

## Future Expansion

### Planned Additions
- [New device or service]
- [Network upgrade plan]

## Notes
[Any additional network configuration notes]
