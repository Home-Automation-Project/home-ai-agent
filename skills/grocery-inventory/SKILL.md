---
name: "grocery-inventory"
description: "Query pantry inventory, expiration dates, and stock levels"
category: "food-management"
risk_level: "low"
requires_confirmation_for: []
allowed_tools:
  - "grocy_api"
  - "rest_api"
---

# Grocery Inventory Skill

## Purpose
Query Grocy inventory system. Check stock levels, expiration dates, shopping needs.

## When to Use
- Check current pantry/fridge inventory
- Look up expiration dates
- Generate shopping lists
- Identify expiring items
- Track stock levels
- Suggest "use first" items

## When NOT to Use
- Modify inventory directly (use meal-planning)
- Delete items without reason
- Override family preferences

## Step-by-Step Behavior

### Query Inventory
```
1. Connect to Grocy API
2. List all inventory items
3. Include stock levels and locations
4. Return formatted inventory
```

### Check Expiration
```
1. Query expiration dates
2. Identify items expiring soon (next 7 days)
3. Sort by expiration date
4. Return prioritized expiration list
```

### Generate Shopping List
```
1. Query low-stock items
2. Identify dietary needs
3. Create prioritized shopping list
4. Return with quantities
```

## Safety Rules
- **Respect dietary restrictions**
- **Don't oversuggest shopping**
- **Prioritize expiring items**

## Example Requests

**Request**: "What's expiring soon?"
**Response**:
```
Expiring soon (next 7 days):
- Milk: expires June 25 (2 days)
- Bread: expires June 26 (3 days)
- Yogurt: expires June 28 (5 days)

⚠️ Use milk and bread first!
```

**Request**: "What do we need to buy?"
**Response**:
```
Shopping suggestions:
- Milk (current: 0.5L, need: 1L minimum)
- Eggs (current: 3, need: 1 dozen)
- Coffee (low: 1 bag)

Optional:
- Cheese (on sale this week)
```

## Implementation Notes
- Endpoint: `GET /integrations/grocery/inventory`
- Mock mode: Returns mock inventory
- Rate limit: 10 requests/minute
- Timeout: 8 seconds
