import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var onboardingCompleted: Bool
    
    @State private var familyName: String = ""
    @State private var familySize: Int = 2
    
    // Dietary preferences selection
    let dietOptions = ["Vegetarian", "Vegan", "Gluten-Free", "Dairy-Free", "Keto", "Nut-Free", "Low-Carb"]
    @State private var selectedDiets: Set<String> = []
    
    // Cuisine preferences selection
    let cuisineOptions = ["Italian", "Mexican", "Asian", "Indian", "Mediterranean", "American", "French", "Middle Eastern"]
    @State private var selectedCuisines: Set<String> = []
    
    var body: some View {
        ZStack {
            // Sleek dark-mode inspired background with gradients
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.12, blue: 0.18), Color(red: 0.05, green: 0.06, blue: 0.09)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 28) {
                    // Header logo/text
                    VStack(spacing: 8) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 72))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.green, Color.teal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.top, 20)
                        
                        Text("PantryPlanner")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Your household food OS, powered by AI")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Box 1: Family Basics
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Household")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            TextField("Family Name (e.g. Smith Family)", text: $familyName)
                                .padding()
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            
                            HStack {
                                Text("Household Size")
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Button(action: { if familySize > 1 { familySize -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                }
                                Text("\(familySize)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 40)
                                Button(action: { familySize += 1 }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
                    
                    // Box 2: Dietary Preferences
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Dietary Needs")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150))], spacing: 8) {
                            ForEach(dietOptions, id: \.self) { diet in
                                let isSelected = selectedDiets.contains(diet)
                                Button(action: {
                                    if isSelected {
                                        selectedDiets.remove(diet)
                                    } else {
                                        selectedDiets.insert(diet)
                                    }
                                }) {
                                    Text(diet)
                                        .font(.system(size: 13, weight: .medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(isSelected ? Color.green : Color.white.opacity(0.06))
                                        .foregroundColor(isSelected ? .black : .white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(isSelected ? Color.green : Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(16)
                    
                    // Box 3: Cuisine Preferences
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Favourite Cuisines")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150))], spacing: 8) {
                            ForEach(cuisineOptions, id: \.self) { cuisine in
                                let isSelected = selectedCuisines.contains(cuisine)
                                Button(action: {
                                    if isSelected {
                                        selectedCuisines.remove(cuisine)
                                    } else {
                                        selectedCuisines.insert(cuisine)
                                    }
                                }) {
                                    Text(cuisine)
                                        .font(.system(size: 13, weight: .medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(isSelected ? Color.teal : Color.white.opacity(0.06))
                                        .foregroundColor(isSelected ? .black : .white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(isSelected ? Color.teal : Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(16)
                    
                    // Submit Button
                    Button(action: saveProfile) {
                        Text("Let's Cook!")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.teal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(14)
                            .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(familyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(familyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func saveProfile() {
        let profileName = familyName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !profileName.isEmpty else { return }
        
        let newProfile = FamilyProfile(
            name: profileName,
            size: familySize,
            dietaryPreferences: Array(selectedDiets),
            cuisinePreferences: Array(selectedCuisines)
        )
        
        modelContext.insert(newProfile)
        
        // Also pre-populate 5 simple starter recipes to make the app feel alive and friendly right away!
        prepopulateStarterRecipes()
        
        do {
            try modelContext.save()
            onboardingCompleted = true
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
    
    private func prepopulateStarterRecipes() {
        let starters = [
            Recipe(
                name: "Classic Tomato Pasta",
                servings: 4,
                cookTimeMinutes: 20,
                cuisine: "Italian",
                ingredients: [
                    Ingredient(name: "Spaghetti", quantity: 400, unit: "g", category: .pantry),
                    Ingredient(name: "Canned Tomatoes", quantity: 800, unit: "g", category: .pantry),
                    Ingredient(name: "Garlic Cloves", quantity: 3, unit: "items", category: .produce),
                    Ingredient(name: "Olive Oil", quantity: 2, unit: "tbsp", category: .pantry),
                    Ingredient(name: "Parmesan Cheese", quantity: 50, unit: "g", category: .dairy),
                    Ingredient(name: "Fresh Basil", quantity: 1, unit: "bunch", category: .produce)
                ],
                isFavourite: true,
                instructions: "1. Cook spaghetti in boiling salted water.\n2. In a pan, sauté minced garlic in olive oil.\n3. Add canned tomatoes and simmer for 10 minutes.\n4. Drain pasta and mix with sauce.\n5. Serve with fresh basil and grated Parmesan."
            ),
            Recipe(
                name: "Avocado & Egg Toast",
                servings: 2,
                cookTimeMinutes: 10,
                cuisine: "American",
                ingredients: [
                    Ingredient(name: "Sourdough Bread", quantity: 2, unit: "slices", category: .bakery),
                    Ingredient(name: "Ripe Avocado", quantity: 1, unit: "items", category: .produce),
                    Ingredient(name: "Eggs", quantity: 2, unit: "items", category: .dairy),
                    Ingredient(name: "Salt & Pepper", quantity: 1, unit: "pinch", category: .pantry)
                ],
                isFavourite: false,
                instructions: "1. Toast sourdough slices.\n2. Mash avocado with salt and pepper, then spread onto toast.\n3. Fry eggs to your liking (sunny-side up recommended) and place on top."
            ),
            Recipe(
                name: "Easy Chicken Quesadilla",
                servings: 2,
                cookTimeMinutes: 15,
                cuisine: "Mexican",
                ingredients: [
                    Ingredient(name: "Flour Tortillas", quantity: 2, unit: "items", category: .bakery),
                    Ingredient(name: "Cooked Chicken Breast", quantity: 200, unit: "g", category: .meat),
                    Ingredient(name: "Cheddar Cheese", quantity: 100, unit: "g", category: .dairy),
                    Ingredient(name: "Bell Pepper", quantity: 1, unit: "items", category: .produce),
                    Ingredient(name: "Salsa", quantity: 4, unit: "tbsp", category: .pantry)
                ],
                isFavourite: true,
                instructions: "1. Dice bell pepper and sauté until soft.\n2. Shred cooked chicken breast.\n3. Lay one tortilla in a hot pan, sprinkle cheese, chicken, sautéed peppers, and salsa.\n4. Fold tortilla in half. Cook until golden brown and cheese is melted, about 3 mins per side."
            )
        ]
        
        for recipe in starters {
            modelContext.insert(recipe)
        }
    }
}

