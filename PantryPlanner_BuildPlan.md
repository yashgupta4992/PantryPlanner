# PantryPlanner — App Build Plan

> A household food OS that helps families plan meals, build smart grocery lists, and reduce food waste — powered by AI.

---

## The Problem

Every weekend, millions of families ask the same questions:
- "What should we cook this week?"
- "What do we need to buy?"
- "What's going to expire before we use it?"

Families already know their go-to meals and usual ingredients — they just need software to organise it. PantryPlanner solves this by combining a personalised recipe library, weekly meal planning, auto-generated grocery lists, and AI-driven recommendations in one app.

---

## Core Features

### 1. Family Profile
- Set household size, dietary preferences, and cuisine types
- Tag intolerances and allergies (gluten-free, nut-free, etc.)
- Profiles sync across all family members' devices

### 2. Recipe Library
- Add your family's regular recipes manually or via photo import
- Store ingredients with quantities and servings
- Tag recipes by cuisine, cook time, and difficulty
- Mark favourites and most-cooked meals

### 3. Weekly Meal Planner
- Drag-and-drop meals into a Mon–Sun grid
- Visual week overview at a glance
- Swap meals easily, scale servings per night
- Copy last week's plan as a starting point

### 4. Smart Grocery List
- Auto-generated from the weekly meal plan
- Grouped by category: produce, dairy, meat, pantry, etc.
- Detects duplicate ingredients across multiple meals and consolidates
- Check off items while shopping; list resets each week
- Add one-off items manually

### 5. AI Meal Suggestions *(Phase 2)*
- Recommends new meals based on cooking history and family preferences
- "Cook something new" mode: suggests recipes outside your usual rotation
- Considers season, budget, and dietary goals
- Powered by Claude API

### 6. Expiry & Waste Tracker *(Phase 2)*
- Log what you buy and when
- App estimates shelf life per ingredient
- "Use it up" screen shows what's expiring soon
- Suggests recipes that use the at-risk items
- Weekly waste report to build better habits

### 7. Full AI Meal Planning *(Phase 3)*
- Natural language: "Plan my week — we're trying to eat less meat"
- AI generates a complete 7-day plan with grocery list
- Budget mode, nutrition balance mode, quick-cook mode
- Learns preferences over time to improve suggestions

---

## Tech Stack

| Layer | Technology | Reason |
|---|---|---|
| Language | Swift | Native iOS, excellent SwiftUI support |
| UI Framework | SwiftUI | Modern, declarative, live previews in Xcode |
| Local storage | SwiftData | Apple-native, no backend needed in Phase 1 |
| Family sync | CloudKit | Free with Apple Developer account, seamless |
| AI features | Claude API (Anthropic) | Meal suggestions, waste detection, planning |
| Backend | None (Phase 1–2) | Everything on-device, zero server costs |

---

## Build Phases

### Phase 1 — MVP (Months 1–3)
*Goal: A working app real families use every weekend*

- [ ] Xcode project setup with SwiftUI
- [ ] Family onboarding screen (size, dietary preferences)
- [ ] Recipe model: name, ingredients, servings, cuisine tag
- [ ] Recipe list & detail screens
- [ ] Add/edit recipe flow
- [ ] Weekly meal plan grid (Mon–Sun)
- [ ] Auto-generated grocery list from meal plan
- [ ] Ingredient consolidation (combine duplicates)
- [ ] Check-off shopping mode
- [ ] Basic settings (household size, reset week)

**Exit criteria:** 20 real families using it every weekend for 4+ weeks

---

### Phase 2 — Intelligence Layer (Months 4–6)
*Goal: The app that knows your family*

- [ ] Cooking history log ("mark as cooked")
- [ ] Purchase history tracker
- [ ] Shelf life database per ingredient category
- [ ] Expiry notification system (push alerts)
- [ ] "Use it up" recipe suggestions screen
- [ ] Claude API integration for meal recommendations
- [ ] Recipe suggestions based on history + preferences
- [ ] Family sharing (multi-device, CloudKit sync)

**Exit criteria:** 70%+ weekly active retention, <15% food waste reported by users

---

### Phase 3 — AI-First Experience (Months 7–12)
*Goal: The app that plans for you*

- [ ] Natural language meal planning ("plan a light week")
- [ ] Full AI-generated weekly plans with one tap
- [ ] Budget mode (estimated weekly spend)
- [ ] Nutritional balance tracking
- [ ] Seasonal ingredient recommendations
- [ ] Smart shopping order (grouped by store layout)
- [ ] Recipe import from URL / web
- [ ] Barcode scanner for adding purchased items

**Exit criteria:** Premium conversion rate >8%, App Store rating ≥ 4.6

---

## Data Models

### Family
```swift
struct Family {
    var id: UUID
    var name: String
    var size: Int
    var dietaryPreferences: [String]   // "vegetarian", "gluten-free", etc.
    var cuisinePreferences: [String]   // "Italian", "Asian", "Mexican"
}
```

### Recipe
```swift
struct Recipe {
    var id: UUID
    var name: String
    var servings: Int
    var cookTimeMinutes: Int
    var cuisine: String
    var ingredients: [Ingredient]
    var isFavourite: Bool
    var timesCooked: Int
}
```

### Ingredient
```swift
struct Ingredient {
    var id: UUID
    var name: String
    var quantity: Double
    var unit: String   // "g", "ml", "cups", "items"
    var category: GroceryCategory
}
```

### Meal Plan
```swift
struct WeeklyPlan {
    var id: UUID
    var weekStartDate: Date
    var days: [DayPlan]   // 7 entries, Mon–Sun
}

struct DayPlan {
    var date: Date
    var meals: [Recipe]   // can have multiple (lunch + dinner)
}
```

---

## Monetisation

| Tier | Price | Features |
|---|---|---|
| Free | $0 | Up to 10 recipes, basic grocery list, 1 device |
| Premium | $3.99/mo or $29.99/yr | Unlimited recipes, AI suggestions, expiry tracking, family sharing (up to 6 devices) |
| Future | TBD | White-label for meal kit companies, grocery store integrations |

**Revenue model:** Subscription-first. Families who use this weekly are the highest-retention segment in consumer apps — weekly habit = strong retention = predictable MRR.

---

## Competitive Landscape

| App | Strength | Gap PantryPlanner fills |
|---|---|---|
| AnyList | Great grocery lists | No meal planning, no AI |
| Mealime | Good meal planning | No custom family recipes, no waste tracking |
| Paprika | Deep recipe library | No grocery intelligence or waste prevention |
| Whisk | Broad recipe discovery | Not personalised to your family's habits |

**PantryPlanner's edge:** It learns *your* family — not generic recipes, but the 20 meals you actually make — and builds everything around that.

---

## Weekend Zero — What to Build First

Before writing any code, validate the concept with paper prototypes or Figma mockups. Then:

1. Install Xcode, create a new SwiftUI project
2. Define the `Recipe` and `Ingredient` models with SwiftData
3. Build a simple recipe list screen with add/edit
4. Add a 7-day grid view with recipe picker
5. Generate a flat ingredient list from selected meals

That's your proof of concept. If it feels good to use, build Phase 1 fully.

---

## Key Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Low adoption: families don't change habits | Make onboarding pre-load 10 common family meals to reduce friction |
| AI costs too high at scale | Cache AI suggestions; only call API when history changes meaningfully |
| Competing with free meal planners | Differentiation is the waste-prevention layer — no competitor does this well |
| App Store approval delays | Submit MVP early; avoid anything requiring special entitlements in Phase 1 |

---

*Last updated: June 2026*
*Status: Pre-development — concept validated, ready to build*
