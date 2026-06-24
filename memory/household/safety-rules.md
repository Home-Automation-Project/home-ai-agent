# Household Safety Rules

## Critical Safety Rules (MUST NEVER BREAK)

### Door Locks
- **Rule**: Never unlock any door without explicit user confirmation
- **Exception**: Only during life safety emergency
- **Logging**: All unlock attempts must be logged with context

### Security System
- **Rule**: Never disable or bypass security system without explicit user confirmation
- **Exception**: Only during setup or maintenance windows
- **Notification**: Always notify users of security changes

### Fire/Smoke Systems
- **Rule**: Never interfere with smoke detectors or fire alarms
- **Exception**: None
- **Action**: If triggered, notify emergency contacts immediately

### Water Systems
- **Rule**: Never close main water shut-off valve automatically
- **Exception**: Only upon explicit user command or detected emergency (major leak)
- **Confirmation**: If emergency closure, user must confirm immediately afterward

### Emergency Shut-offs
- **Gas shut-off**: Manual only, no automation
- **Electrical breaker**: Manual only, no automation
- **HVAC**: Can be disabled by automated routines only in extreme temperature situations

## Device Safety Rules

### Thermostat
- **Min temperature**:  [Your minimum comfortable temp, typically 62°F]
- **Max temperature**: [Your maximum comfortable temp, typically 78°F]
- **Rate of change**: Max ±3°F per 30 minutes (prevent shock)
- **Away mode**: Energy save temperature (typically 68°F winter, 78°F summer)
- **Exception**: Allow explicit user override

### Garage Door
- **Rule**: Auto-close after 10 minutes if left open
- **Notification**: Warn user if garage door is open during "Away" mode
- **Safety sensor**: Never ignore safety beam obstruction alerts
- **Manual override**: Always allowed

### Lighting
- **Rule**: Never turn lights on at full brightness during night (1 AM - 5 AM)
- **Rationale**: Safety - prevent eye strain and falls if user gets up
- **Exception**: Upon explicit user request

### Climate Control
- **Extreme temperature alert**: If outdoor temp < 20°F or > 100°F, monitor heating/cooling performance
- **HVAC failure alert**: Alert user if temperature deviates >5°F from setpoint for >30 minutes

## Access Control Rules

### User Authentication
- **Level 1** (Read-only): No authentication required
- **Level 2** (Write, non-destructive): User confirmation required
- **Level 3** (Destructive, safety-critical): Explicit user approval + confirmation logging required

### Remote Access
- **API calls**: Require valid API token
- **Mobile app**: Require mobile device authentication
- **Web interface**: Require username/password + optional 2FA

### OpenClaw Agent Access
- **Agent authentication**: Token-based
- **Agent permissions**: Defined per agent in config/permissions.yaml
- **Escalation**: Safety-critical actions always escalate to user

## Geofence Rules

### "Away" Detection
- **Trigger**: All registered devices leave geofence
- **Actions**: Lock doors, arm security, set energy-save mode
- **Confirmation**: None (automatic for safety)

### "Arriving Home" Detection
- **Trigger**: First device enters geofence
- **Actions**: Unlock door, disable alarm chime, set normal mode
- **Confirmation**: None (user initiated by arriving)

### Partial Away
- **Definition**: Some devices away, some home
- **Behavior**: No automatic security actions; manual control recommended
- **Notification**: Alert user of mixed occupancy state

## Guest Access Rules

### Temporary Guest
- **Duration**: Single access or defined time window
- **Actions**: Unlock specific door(s), enable guest WiFi
- **Restrictions**: No security system access, no critical device control
- **Cleanup**: Auto-revoke access after time window

### Extended Guest
- **Duration**: Multiple days (e.g., visiting family)
- **Actions**: Temporary code, limited device access
- **Restrictions**: No financial transactions, no permanent changes
- **Notification**: Daily reminder to host that guest access is active

## Maintenance Access Rules

### Service Technician
- **Duration**: Scheduled maintenance window
- **Actions**: Unlock specific area, disable alarms for area only
- **Monitoring**: Log all actions during service
- **Cleanup**: Auto-revoke access after window, restore alarms

## Health & Safety Alerts

### Water Leak Detection
- **Alert threshold**: Any flow > 0.1 GPM for > 5 minutes without activity
- **First action**: Alert user (mobile notification)
- **Second action** (if not acknowledged): Auto-close main water valve
- **Notification**: All family members notified of water shut-off

### Gas Leak Detection
- **Alert threshold**: Any gas sensor reading > [threshold]
- **First action**: Alert user immediately
- **Second action**: Disable any gas appliances (if smart)
- **Third action**: Call emergency services (future feature)

### Temperature Extremes
- **Heat alert**: Indoor temp > 85°F for > 30 minutes
- **Cold alert**: Indoor temp < 55°F for > 30 minutes
- **Action**: Notify user, check HVAC status

### Motion Intrusion
- **Trigger**: Motion detected during "Away" + Security Arm = Potential intrusion
- **Action**: Alert user, enable siren/lights
- **Verification**: User must confirm false alarm or authorize emergency response

## Network Security Rules

### WiFi Security
- **Authentication**: WPA3 preferred, WPA2 minimum
- **Guest network**: Separate from home network
- **Device whitelisting**: Review unknown devices periodically

### API Security
- **Token rotation**: Every 90 days
- **Rate limiting**: [Configured in integration-config.yaml]
- **SSL/TLS**: Required for all external connections

## Data Privacy Rules

### Personal Information
- **Sensitive data**: No personal info in logs unless necessary for security
- **Audit trails**: Reviewed monthly for compliance
- **Retention**: 90 days for normal logs, 1 year for security logs

### Third-Party Integrations
- **OAuth**: Prefer OAuth over token storage
- **Data sharing**: Minimize; only share necessary data
- **Revocation**: Easy method to revoke third-party access

## Emergency Override

### User Emergency Override
- **Key**: User can always override any automated action
- **Logging**: All overrides logged for audit
- **Notification**: No special confirmation for overrides (user initiated)

### Manual Override
- **Physical**: All smart devices have manual override (not automated)
- **Web interface**: Direct user control always available

## Notes
[Any additional household safety considerations or special configurations]
