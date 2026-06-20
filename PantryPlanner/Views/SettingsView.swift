import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [FamilyProfile]
    
    // Diet and Cuisine Options (Must match OnboardingView)
    let dietOptions = ["Vegetarian", "Vegan", "Gluten-Free", "Dairy-Free", "Keto", "Nut-Free", "Low-Carb"]
    let cuisineOptions = ["Italian", "Mexican", "Asian", "Indian", "Mediterranean", "American", "French", "Middle Eastern"]
    
    @State private var showingResetAlert = false
    
    var profile: FamilyProfile? {
        profiles.first
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let profile = profile {
                            // Section 1: Household Profile Details
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Household Profile")
                                    .font(.headline)
                                    .foregroundColor(.teal)
                                
                                VStack(spacing: 12) {
                                    // Custom binding to handle SwiftData changes instantly
                                    HStack {
                                        Text("Family Name")
                                            .foregroundColor(.white.opacity(0.8))
                                        Spacer()
                                        TextField("Name", text: Binding(
                                            get: { profile.name },
                                            set: { profile.name = $0 }
                                        ))
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                        .frame(width: 180)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.06))
                                    .cornerRadius(10)
                                    
                                    HStack {
                                        Text("Household Size")
                                            .foregroundColor(.white.opacity(0.8))
                                        Spacer()
                                        Stepper("\(profile.size) people", value: Binding(
                                            get: { profile.size },
                                            set: { profile.size = max(1, $0) }
                                        ))
                                        .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.06))
                                    .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                            
                            // Section 2: Dietary Needs
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Dietary Restrictions")
                                    .font(.headline)
                                    .foregroundColor(.teal)
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150))], spacing: 8) {
                                    ForEach(dietOptions, id: \.self) { diet in
                                        let isSelected = profile.dietaryPreferences.contains(diet)
                                        Button(action: {
                                            var diets = profile.dietaryPreferences
                                            if isSelected {
                                                diets.removeAll { $0 == diet }
                                            } else {
                                                diets.append(diet)
                                            }
                                            profile.dietaryPreferences = diets
                                            try? modelContext.save()
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
                            .cornerRadius(14)
                            
                            // Section 3: Favourite Cuisines
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Favourite Cuisines")
                                    .font(.headline)
                                    .foregroundColor(.teal)
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150))], spacing: 8) {
                                    ForEach(cuisineOptions, id: \.self) { cuisine in
                                        let isSelected = profile.cuisinePreferences.contains(cuisine)
                                        Button(action: {
                                            var cuisines = profile.cuisinePreferences
                                            if isSelected {
                                                cuisines.removeAll { $0 == cuisine }
                                            } else {
                                                cuisines.append(cuisine)
                                            }
                                            profile.cuisinePreferences = cuisines
                                            try? modelContext.save()
                                        }) {
                                            Text(cuisine)
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
                            .cornerRadius(14)
                        }
                        
                        // Premium Tier Promotion Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                                Text("PantryPlanner Premium")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("$3.99/mo")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.15))
                                    .foregroundColor(.yellow)
                                    .cornerRadius(6)
                            }
                            
                            Text("Unlock the full power of a household food OS:")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.yellow)
                                    Text("AI Meal Suggestions (Phase 2)")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                HStack(spacing: 8) {
                                    Image(systemName: "hourglass.badge.plus")
                                        .foregroundColor(.yellow)
                                    Text("Expiry & Waste Tracker (Phase 2)")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                HStack(spacing: 8) {
                                    Image(systemName: "icloud.and.arrow.up")
                                        .foregroundColor(.yellow)
                                    Text("Cloud Sharing & Sync with family")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .font(.caption)
                            
                            Button(action: {}) {
                                Text("Upgrade Now")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.yellow)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                        )
                        
                        // Reset App Data
                        Button(action: { showingResetAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Reset All App Data")
                            }
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.08))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .alert("Reset All Data?", isPresented: $showingResetAlert) {
                Button("Reset Everything", role: .destructive, action: resetAppDatabase)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all recipes, custom shopping lists, meal plans, and your household profile. This action cannot be undone.")
            }
        }
    }
    
    private func resetAppDatabase() {
        do {
            try modelContext.delete(model: FamilyProfile.self)
            try modelContext.delete(model: Recipe.self)
            try modelContext.delete(model: WeeklyPlan.self)
            try modelContext.delete(model: DayPlan.self)
            try modelContext.delete(model: CustomGroceryItem.self)
            try modelContext.save()
        } catch {
            print("Failed to reset database: \(error)")
        }
    }
}
