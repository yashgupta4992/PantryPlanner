import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    
    @State private var searchText = ""
    @State private var selectedCuisine: String = "All"
    @State private var showFavouritesOnly = false
    @State private var showingAddRecipeSheet = false
    
    var availableCuisines: [String] {
        let cuisines = Set(recipes.map { $0.cuisine })
        return ["All"] + Array(cuisines).sorted()
    }
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            
            let matchesCuisine = selectedCuisine == "All" || recipe.cuisine == selectedCuisine
            
            let matchesFavourite = !showFavouritesOnly || recipe.isFavourite
            
            return matchesSearch && matchesCuisine && matchesFavourite
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search recipes or ingredients...", text: $searchText)
                            .foregroundColor(.white)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Filter bar (horizontal scroll)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            // Favourites Filter
                            Button(action: { showFavouritesOnly.toggle() }) {
                                HStack(spacing: 6) {
                                    Image(systemName: showFavouritesOnly ? "heart.fill" : "heart")
                                        .foregroundColor(showFavouritesOnly ? .red : .gray)
                                    Text("Favourites")
                                }
                                .font(.system(size: 13, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(showFavouritesOnly ? Color.red.opacity(0.15) : Color.white.opacity(0.06))
                                .foregroundColor(showFavouritesOnly ? .red : .white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(showFavouritesOnly ? Color.red.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            
                            // Cuisine Filters
                            ForEach(availableCuisines, id: \.self) { cuisine in
                                let isSelected = selectedCuisine == cuisine
                                Button(action: { selectedCuisine = cuisine }) {
                                    Text(cuisine)
                                        .font(.system(size: 13, weight: .medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(isSelected ? Color.green : Color.white.opacity(0.06))
                                        .foregroundColor(isSelected ? .black : .white)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    
                    if filteredRecipes.isEmpty {
                        VStack(spacing: 12) {
                            Spacer()
                            Image(systemName: "fork.knife")
                                .font(.system(size: 54))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No recipes found")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            Text("Add your own custom family recipe or clear your filters to get started.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Spacer()
                        }
                    } else {
                        // Recipe list with native swipe-to-delete
                        List {
                            ForEach(filteredRecipes) { recipe in
                                ZStack {
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        EmptyView()
                                    }
                                    .opacity(0) // Hide the standard chevron and disclosure indicator
                                    
                                    RecipeRowView(recipe: recipe)
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: deleteRecipes)
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Recipe Library")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddRecipeSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipeSheet) {
                AddEditRecipeView()
            }
        }
    }
    
    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let recipe = filteredRecipes[index]
                modelContext.delete(recipe)
            }
            try? modelContext.save()
        }
    }
}

// Subview for a recipe card in the list
struct RecipeRowView: View {
    @Bindable var recipe: Recipe
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(recipe.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            recipe.isFavourite.toggle()
                        }
                    }) {
                        Image(systemName: recipe.isFavourite ? "heart.fill" : "heart")
                            .foregroundColor(recipe.isFavourite ? .red : .gray)
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.plain)
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        Text("\(recipe.servings) serv")
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text("\(recipe.cookTimeMinutes) mins")
                    }
                    
                    Spacer()
                    
                    Text(recipe.cuisine)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.08))
                        .foregroundColor(.teal)
                        .cornerRadius(6)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.03))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
        }
    }
}
