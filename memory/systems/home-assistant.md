# Home Assistant Configuration and Entity Map

## Connection Details
- **URL**: http://had.lthome.us
- **Port**: 8123
- **API Version**: 2024.1
- **Token**: [Stored in .env as HOME_ASSISTANT_TOKEN]
- **Protocol**: HTTP/HTTPS (configure as needed)
- **Timeout**: 10 seconds (default)

## Entity Groups

### Climate Control
- `climate.living_room_thermostat` - Main thermostat
- `climate.upstairs_zone` - Upstairs HVAC zone (if separate)
- `climate.basement_zone` - Basement HVAC zone (if applicable)
- Automations: `automation.climate_comfort`, `automation.climate_energy_save`

### Lighting
- `group.all_lights` - All lights in home
- `group.living_room_lights` - Living room lights
- `group.kitchen_lights` - Kitchen lights
- `group.bedroom_lights` - Bedroom lights
- `group.outdoor_lights` - Porch, patio, driveway lights
- Scene: `scene.movie_mode` - Dim all lights for movie
- Scene: `scene.bedtime` - All lights off except bedroom
- Scene: `scene.away_mode` - Random lights for security

### Door Locks
- `lock.front_door` - Front door lock
- `lock.back_door` - Back door lock
- `lock.garage_side_door` - Garage entry door
- Automations: `automation.door_lock_at_night`, `automation.door_unlock_on_arrive`

### Garage Doors
- `cover.garage_door_main` - Main garage door
- `cover.garage_door_secondary` - Secondary garage door (if applicable)
- Automations: `automation.garage_door_auto_close`

### Security System
- `alarm_control_panel.home_alarm` - Main security system
- `binary_sensor.front_door_contact` - Front door contact sensor
- `binary_sensor.back_door_contact` - Back door contact sensor
- `binary_sensor.front_window_contact` - Front window (if equipped)
- `motion_sensor.living_room` - Living room motion
- `motion_sensor.garage` - Garage motion

### Water Monitoring
- `sensor.main_water_usage` - Main water meter
- `sensor.water_temperature` - Incoming water temperature
- Automations: `automation.water_leak_alert`, `automation.unusual_usage_detection`

### Irrigation
- `switch.front_irrigation` - Front lawn sprinklers
- `switch.back_irrigation` - Back yard sprinklers
- `switch.side_irrigation` - Side yard sprinklers (if applicable)
- Automations: `automation.daily_irrigation_schedule`, `automation.rain_skip`

### Appliances
- `sensor.washer_status` - Washer status (if smart)
- `sensor.dryer_status` - Dryer status (if smart)
- `sensor.dishwasher_status` - Dishwasher status (if smart)

### Presence / Occupancy
- `person.occupant_1` - Primary person tracking
- `person.occupant_2` - Secondary person (if applicable)
- `input_boolean.occupancy_override` - Manual occupancy override
- `input_boolean.guest_mode` - Guest mode flag

### Media / Entertainment
- `media_player.living_room_tv` - Living room TV (if controllable)
- `media_player.bedroom_tv` - Bedroom TV (if controllable)
- `media_player.whole_house_audio` - Whole-house audio system (if applicable)

## Important Automations

### Morning Routine
- **ID**: `automation.morning_routine`
- **Trigger**: Time 06:30 AM
- **Actions**: Lights on, temperature adjustment, coffee maker
- **Skip conditions**: Weekend, vacation mode

### Evening Routine
- **ID**: `automation.evening_routine`
- **Trigger**: Time 09:00 PM
- **Actions**: Lights off (except bedroom), temperature adjustment, doors locked

### Bedtime
- **ID**: `automation.bedtime_routine`
- **Trigger**: Time 10:30 PM
- **Actions**: All lights off, doors double-check, security arm

### Away Mode
- **ID**: `automation.leave_home`
- **Trigger**: All occupancy sensors show "away"
- **Actions**: Garage door close, doors lock, security arm, lights to "away" mode

### Arrival
- **ID**: `automation.arrive_home`
- **Trigger**: Any occupancy sensor detects arrival
- **Actions**: Garage door open, door unlock (front), lights on, security disarm

### Water Leak Detection
- **ID**: `automation.water_leak_alert`
- **Trigger**: Water flow > 0.1 GPM for 5 minutes
- **Actions**: Alert user, optionally close main valve
- **Confirmation**: Requires user acknowledgment

### Unusual Water Usage
- **ID**: `automation.unusual_usage_detection`
- **Trigger**: Daily usage > [threshold] gallons or hourly usage spike
- **Actions**: Alert user, log to memory

### System Health Check
- **ID**: `automation.daily_system_check`
- **Trigger**: Time 06:00 AM daily
- **Actions**: Check all critical devices, log status, alert on failures

## Custom Scripts

### Irrigation Control
- **Script**: `script.irrigation_cycle`
- **Purpose**: Manage irrigation zones with rain skip logic
- **Parameters**: Zone, duration, rain_skip_enabled

### Emergency Lockdown
- **Script**: `script.emergency_lockdown`
- **Purpose**: Lock all doors, arm security, disable automations
- **Parameters**: Duration, notification_contacts

## Known Issues & Workarounds

### [Issue 1]
- **Description**: [Describe issue]
- **Workaround**: [Describe workaround or automation]
- **Status**: [In progress / Resolved / Open]

## Integration Notes

### Z-Wave Devices
- **Controller**: [Model and location]
- **Devices**: [List of Z-Wave devices]
- **Notes**: [Any known compatibility issues]

### Zigbee Devices
- **Coordinator**: [Model and location]
- **Devices**: [List of Zigbee devices]
- **Notes**: [Any known compatibility issues]

### WiFi Devices
- **SSID**: [Network name]
- **Band**: 2.4 GHz / 5 GHz
- **Devices**: [List of WiFi devices]

## Future Integrations
- [Device/Service not yet integrated]
- [Device/Service planned for integration]

## Notes
[Any additional Home Assistant configuration notes]
