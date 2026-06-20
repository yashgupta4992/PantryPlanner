import SwiftUI
import SwiftData

struct AddEditRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var recipe: Recipe? // nil means we are adding a new recipe
    
    @State private var name: String = ""
    @State private var servings: Int = 4
    @State private var cookTimeMinutes: Int = 30
    @State private var cuisine: String = "General"
    @State private var instructions: String = ""
    @State private var isFavourite: Bool = false
    
    // Ingredients list in progress
    @State private var draftIngredients: [Ingredient] = []
    
    // New ingredient form states
    @State private var newIngName: String = ""
    @State private var newIngQty: String = ""
    @State private var newIngUnit: String = "g"
    @State private var newIngCategory: GroceryCategory = .pantry
    
    let units = ["g", "ml", "items", "cups", "tbsp", "tsp", "slices", "cans", "pinches"]
    let cuisines = ["Italian", "Mexican", "Asian", "Indian", "Mediterranean", "American", "French", "Middle Eastern", "General"]
    
    var isEditMode: Bool {
        recipe != nil
    }
    
    private var filteredSuggestions: [PredefinedIngredient] {
        let query = newIngName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return [] }
        return predefinedIngredients.filter { predefined in
            predefined.name.lowercased().contains(query) &&
            predefined.name.lowercased() != query &&
            !draftIngredients.contains(where: { $0.name.lowercased() == predefined.name.lowercased() })
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        // Section 1: Recipe Basics
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Recipe Details")
                                .font(.headline)
                                .foregroundColor(.teal)
                            
                            TextField("Recipe Name", text: $name)
                                .padding()
                                .background(Color.white.opacity(0.06))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                            HStack {
                                Text("Cuisine")
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Picker("Cuisine", selection: $cuisine) {
                                    ForEach(cuisines, id: \.self) { c in
                                        Text(c).tag(c)
                                    }
                                }
                                .tint(.green)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(10)
                            
                            HStack {
                                Text("Servings")
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Stepper("\(servings)", value: $servings, in: 1...20)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(10)
                            
                            HStack {
                                Text("Cook Time (Mins)")
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Stepper("\(cookTimeMinutes)m", value: $cookTimeMinutes, in: 5...180, step: 5)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(14)
                        
                        // Section 2: Add Ingredient Sub-Form
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Add Ingredient")
                                .font(.headline)
                                .foregroundColor(.teal)
                            
                            TextField("Ingredient name (e.g. Eggs)", text: $newIngName)
                                .padding()
                                .background(Color.white.opacity(0.06))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                            if !filteredSuggestions.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(filteredSuggestions) { suggestion in
                                            Button(action: {
                                                newIngName = suggestion.name
                                                newIngUnit = suggestion.defaultUnit
                                                newIngCategory = suggestion.category
                                            }) {
                                                HStack(spacing: 6) {
                                                    Image(systemName: suggestion.category.icon)
                                                        .font(.system(size: 11))
                                                    Text(suggestion.name)
                                                        .font(.system(size: 13, weight: .medium))
                                                }
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(Color.white.opacity(0.12))
                                                .foregroundColor(.white)
                                                .cornerRadius(16)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                                )
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            
                            HStack(spacing: 12) {
                                TextField("Qty", text: $newIngQty)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color.white.opacity(0.06))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(width: 80)
                                
                                Picker("Unit", selection: $newIngUnit) {
                                    ForEach(units, id: \.self) { u in
                                        Text(u).tag(u)
                                    }
                                }
                                .tint(.green)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(10)
                                
                                Picker("Category", selection: $newIngCategory) {
                                    ForEach(GroceryCategory.allCases) { cat in
                                        Text(cat.rawValue).tag(cat)
                                    }
                                }
                                .tint(.green)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(10)
                            }
                            
                            Button(action: addIngredientToDraft) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add to Ingredient List")
                                }
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(10)
                            }
                            .disabled(newIngName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .opacity(newIngName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                        }
                        .padding()
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(14)
                        
                        // Section 3: Ingredients List
                        if !draftIngredients.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Ingredient List")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                ForEach(draftIngredients) { ing in
                                    HStack {
                                        Image(systemName: ing.groceryCategory.icon)
                                            .foregroundColor(.teal)
                                        Text(ing.name)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("\(formatQuantity(ing.quantity)) \(ing.unit)")
                                            .foregroundColor(.gray)
                                        
                                        Button(action: { removeIngredientFromDraft(ing) }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                        // Section 4: Instructions/Notes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cooking Instructions / Notes")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextEditor(text: $instructions)
                                .frame(height: 120)
                                .padding(8)
                                .background(Color.white.opacity(0.06))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(isEditMode ? "Edit Recipe" : "New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .foregroundColor(.green)
                    .fontWeight(.bold)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || draftIngredients.isEmpty)
                }
            }
            .onAppear {
                if let recipe = recipe {
                    // Pre-fill form if editing
                    name = recipe.name
                    servings = recipe.servings
                    cookTimeMinutes = recipe.cookTimeMinutes
                    cuisine = recipe.cuisine
                    instructions = recipe.instructions
                    isFavourite = recipe.isFavourite
                    draftIngredients = recipe.ingredients
                }
            }
        }
    }
    
    private func addIngredientToDraft() {
        let cleanedName = newIngName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedName.isEmpty else { return }
        
        let qty = Double(newIngQty) ?? 1.0
        let newIng = Ingredient(
            name: cleanedName,
            quantity: qty,
            unit: newIngUnit,
            category: newIngCategory
        )
        
        draftIngredients.append(newIng)
        
        // Reset inputs
        newIngName = ""
        newIngQty = ""
        newIngUnit = "g"
        newIngCategory = .pantry
    }
    
    private func removeIngredientFromDraft(_ ing: Ingredient) {
        draftIngredients.removeAll { $0.id == ing.id }
    }
    
    private func saveRecipe() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        if let recipe = recipe {
            // Update existing
            recipe.name = cleanName
            recipe.servings = servings
            recipe.cookTimeMinutes = cookTimeMinutes
            recipe.cuisine = cuisine
            recipe.instructions = instructions
            recipe.ingredients = draftIngredients
        } else {
            // Create new
            let newRecipe = Recipe(
                name: cleanName,
                servings: servings,
                cookTimeMinutes: cookTimeMinutes,
                cuisine: cuisine,
                ingredients: draftIngredients,
                isFavourite: isFavourite,
                timesCooked: 0,
                instructions: instructions
            )
            modelContext.insert(newRecipe)
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }
    
    private func formatQuantity(_ val: Double) -> String {
        if val == floor(val) {
            return String(format: "%.0f", val)
        } else {
            return String(format: "%.2f", val)
        }
    }
}

// MARK: - Predefined Ingredients Autocomplete Database

struct PredefinedIngredient: Identifiable {
    let id = UUID()
    let name: String
    let category: GroceryCategory
    let defaultUnit: String
}

private let predefinedIngredients: [PredefinedIngredient] = [
    // Produce
    PredefinedIngredient(name: "Apple", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Avocado", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Banana", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Bell Pepper", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Broccoli", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Carrot", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Cucumber", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Garlic Cloves", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Ginger", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Lemon", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Lime", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Lettuce", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Mushroom", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Onion", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Potato", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Spinach", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Tomato", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Zucchini", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Ginger-Garlic Paste", category: .produce, defaultUnit: "tbsp"),
    PredefinedIngredient(name: "Green Chilies", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Coriander Leaves", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Curry Leaves", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Okra (Bhindi)", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Cauliflower (Gobi)", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Cabbage (Patta Gobi)", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Eggplant (Baingan)", category: .produce, defaultUnit: "items"),
    PredefinedIngredient(name: "Green Peas (Matar)", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Fenugreek Leaves (Methi)", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Bitter Gourd (Karela)", category: .produce, defaultUnit: "g"),
    PredefinedIngredient(name: "Bottle Gourd (Lauki)", category: .produce, defaultUnit: "items"),
    
    // Dairy & Eggs
    PredefinedIngredient(name: "Butter", category: .dairy, defaultUnit: "g"),
    PredefinedIngredient(name: "Cheddar Cheese", category: .dairy, defaultUnit: "g"),
    PredefinedIngredient(name: "Eggs", category: .dairy, defaultUnit: "items"),
    PredefinedIngredient(name: "Milk", category: .dairy, defaultUnit: "ml"),
    PredefinedIngredient(name: "Heavy Cream", category: .dairy, defaultUnit: "ml"),
    PredefinedIngredient(name: "Greek Yogurt", category: .dairy, defaultUnit: "g"),
    PredefinedIngredient(name: "Parmesan Cheese", category: .dairy, defaultUnit: "g"),
    PredefinedIngredient(name: "Paneer", category: .dairy, defaultUnit: "g"),
    PredefinedIngredient(name: "Ghee", category: .dairy, defaultUnit: "tbsp"),
    
    // Meat & Seafood
    PredefinedIngredient(name: "Bacon", category: .meat, defaultUnit: "g"),
    PredefinedIngredient(name: "Beef Mince", category: .meat, defaultUnit: "g"),
    PredefinedIngredient(name: "Chicken Breast", category: .meat, defaultUnit: "g"),
    PredefinedIngredient(name: "Chicken Thighs", category: .meat, defaultUnit: "g"),
    PredefinedIngredient(name: "Salmon Fillet", category: .meat, defaultUnit: "g"),
    PredefinedIngredient(name: "Pork Chops", category: .meat, defaultUnit: "g"),
    
    // Pantry
    PredefinedIngredient(name: "Canned Tomatoes", category: .pantry, defaultUnit: "cans"),
    PredefinedIngredient(name: "Olive Oil", category: .pantry, defaultUnit: "tbsp"),
    PredefinedIngredient(name: "Soy Sauce", category: .pantry, defaultUnit: "tbsp"),
    PredefinedIngredient(name: "White Rice", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Brown Rice", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Spaghetti", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Penne Pasta", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Flour", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Sugar", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Salt", category: .pantry, defaultUnit: "pinch"),
    PredefinedIngredient(name: "Black Pepper", category: .pantry, defaultUnit: "pinch"),
    PredefinedIngredient(name: "Chicken Stock", category: .pantry, defaultUnit: "ml"),
    PredefinedIngredient(name: "Coconut Milk", category: .pantry, defaultUnit: "cans"),
    PredefinedIngredient(name: "Basmati Rice", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Garam Masala", category: .pantry, defaultUnit: "tsp"),
    PredefinedIngredient(name: "Turmeric Powder", category: .pantry, defaultUnit: "tsp"),
    PredefinedIngredient(name: "Cumin Seeds", category: .pantry, defaultUnit: "tsp"),
    PredefinedIngredient(name: "Coriander Powder", category: .pantry, defaultUnit: "tsp"),
    PredefinedIngredient(name: "Red Chili Powder", category: .pantry, defaultUnit: "tsp"),
    PredefinedIngredient(name: "Red Lentils (Masoor Dal)", category: .pantry, defaultUnit: "g"),
    PredefinedIngredient(name: "Chickpeas (Chole)", category: .pantry, defaultUnit: "g"),
    
    // Bakery
    PredefinedIngredient(name: "Sourdough Bread", category: .bakery, defaultUnit: "slices"),
    PredefinedIngredient(name: "Tortillas", category: .bakery, defaultUnit: "items"),
    PredefinedIngredient(name: "Breadcrumbs", category: .bakery, defaultUnit: "g"),
    PredefinedIngredient(name: "Naan Bread", category: .bakery, defaultUnit: "items"),
    PredefinedIngredient(name: "Roti / Chapati", category: .bakery, defaultUnit: "items")
]
