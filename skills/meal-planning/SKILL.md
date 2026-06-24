---
name: "meal-planning"
description: "Plan meals, suggest recipes, generate shopping lists"
category: "food-management"
risk_level: "low"
requires_confirmation_for: []
allowed_tools:
  - "grocy_api"
  - "rest_api"
---

# Meal Planning Skill

## Purpose
Generate meal plans based on available inventory, dietary preferences, and expiring items.

## When to Use
- Plan daily or weekly meals
- Suggest recipes using available ingredients
- Generate shopping lists for meal plans
- Find recipes for expiring ingredients
- Accommodate dietary preferences
- Minimize food waste

## When NOT to Use
- Make autonomous food purchases
- Override dietary restrictions
- Ignore expiration dates
- Suggest inappropriate combinations

## Step-by-Step Behavior

### Generate Meal Plan
```
1. Query current inventory
2. Check for expiring items (prioritize)
3. Query dietary preferences per family member
4. Generate varied meal suggestions
5. Ensure nutritional balance
6. Return 7-day meal plan or custom period
```

### Suggest Recipes
```
1. Identify available ingredients
2. Check dietary restrictions
3. Query preference memory
4. Suggest 3-5 recipe options
5. Include prep time and difficulty
```

### Generate Shopping List
```
1. Build shopping list from meal plan
2. Remove items already in inventory
3. Group by store section
4. Add budget optimization suggestions
5. Return organized shopping list
```

## Safety Rules
- **Always respect dietary restrictions**
- **Prioritize expiring ingredients**
- **Avoid duplicate/repetitive meals**
- **Ensure nutritional variety**
- **Check for common allergies**

## Example Requests

**Request**: "Plan this week's meals"
**Response**:
```
Weekly Meal Plan (using current inventory):

Monday: Pasta primavera (using expiring broccoli)
Tuesday: Stir-fry (use bell peppers)
Wednesday: Slow cooker chili (comfort meal)
Thursday: Grilled chicken with roasted vegetables
Friday: Tacos (family favorite)
Saturday: Pizza night
Sunday: Roast chicken (leftovers for Mon/Tue)

Shopping needed for: Chicken, pasta sauce, tortillas
```

**Request**: "What can I make with these expiring items?"
**Response**:
```
Expiring items:
- Milk (2 days)
- Bread (3 days)
- Broccoli (1 day)

Suggested recipes:
1. Broccoli cheddar soup (uses all three!)
2. Savory bread pudding
3. Cream of broccoli pasta
```

## Implementation Notes
- Endpoint: Uses grocery-inventory skill
- Mock mode: Returns mock meal plans
- Rate limit: 10 requests/minute
- Timeout: 12 seconds
