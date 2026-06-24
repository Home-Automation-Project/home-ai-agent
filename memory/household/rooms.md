# Household Rooms and Layout

## Home Overview
- **Address**: lthome.us
- **Total Rooms**: [Number]
- **Square Footage**: [Number]
- **Type**: [Single family/Townhouse/Apartment]

## Room Inventory

### Living Spaces
#### Living Room
- **Dimensions**: [size]
- **Automation group**: `group.living_room`
- **Devices**:
  - Smart lights: [Number and type]
  - Thermostat: [Type and entity_id]
  - Smart speaker: [Type]
  - TV: [Type and control method]
- **Occupancy schedule**: [Typical usage times]

#### Kitchen
- **Dimensions**: [size]
- **Automation group**: `group.kitchen`
- **Devices**:
  - Smart lights: [Number and type]
  - Refrigerator: [Smart capable? Yes/No]
  - Dishwasher: [Smart capable?]
  - Other appliances: [List]

#### Primary Bedroom
- **Dimensions**: [size]
- **Automation group**: `group.primary_bedroom`
- **Devices**:
  - Smart lights: [Number and type]
  - Door lock: [Type and entity_id]
  - Temperature control: [Type]
  - Smart speaker: [Type]

#### [Additional Bedrooms]
- [Same structure as above]

### Utility Spaces
#### Garage
- **Dimensions**: [size]
- **Doors**: [Number of garage doors and smart control]
- **Automation group**: `group.garage`
- **Devices**:
  - Garage door opener: [Model and entity_id]
  - Motion sensor: [Model]
  - Lights: [Number and type]

#### Laundry Room
- **Dimensions**: [size]
- **Appliances**:
  - Washer: [Smart capable?]
  - Dryer: [Smart capable?]
  - Sensor for completion: [Yes/No]

#### Utility Room / Closet
- **Purpose**: [Equipment storage, HVAC, etc.]
- **Equipment**: [List of equipment and smart devices]

### Outdoor Areas
#### Front Porch
- **Automation group**: `group.front_porch`
- **Devices**:
  - Smart doorbell: [Model]
  - Motion lights: [Number]
  - Smart lock: [Front door]

#### Back Patio
- **Automation group**: `group.back_patio`
- **Devices**:
  - Lights: [Number and type]
  - Irrigation control: [Model]
  - Motion sensors: [Number]

#### Driveway / Yard
- **Automation group**: `group.outdoor`
- **Devices**:
  - Landscape lights: [Number]
  - Irrigation zones: [Number and types]
  - Motion sensors: [Number]

## Automation Groupings

### By Function
- `group.lighting` - All lights in home
- `group.security` - Locks, cameras, sensors
- `group.climate` - Thermostats, vents
- `group.appliances` - Connected appliances
- `group.water` - Water monitoring, shut-off valves

### By Zone
- `group.ground_floor` - All ground floor devices
- `group.upstairs` - All upstairs devices
- `group.outdoor` - All outdoor devices

## Occupancy Zones
- **Primary zone**: [Living room/bedroom]
- **Secondary zones**: [List]
- **Motion sensors**: [Locations and entity_ids]

## Emergency Equipment
- **Water shut-off valve**: [Location and entity_id if smart]
- **Gas shut-off valve**: [Location and notes]
- **Electrical panel**: [Location]
- **Main breaker**: [Location]

## Restricted Access Areas
- [Areas where agents should not operate devices]

## Notes
[Any additional room layout information or special configurations]
