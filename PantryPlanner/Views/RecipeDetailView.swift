import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var recipe: Recipe
    
    @State private var scaleServings: Int = 4
    @State private var showingEditSheet = false
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.09)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(recipe.cuisine)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.teal.opacity(0.15))
                                .foregroundColor(.teal)
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    recipe.isFavourite.toggle()
                                }
                            }) {
                                Image(systemName: recipe.isFavourite ? "heart.fill" : "heart")
                                    .foregroundColor(recipe.isFavourite ? .red : .gray)
                                    .font(.title3)
                            }
                        }
                        
                        Text(recipe.name)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                Text("\(recipe.cookTimeMinutes) minutes")
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "hand.thumbsup.fill")
                                Text("Cooked \(recipe.timesCooked) times")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
                    
                    // Mark as Cooked Button
                    Button(action: markAsCooked) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark as Cooked")
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    // Serving Scaler
                    VStack(spacing: 12) {
                        Text("Scale Serving Size")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            Button(action: { if scaleServings > 1 { scaleServings -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                            
                            VStack(spacing: 2) {
                                Text("\(scaleServings)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("servings")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 80)
                            
                            Button(action: { scaleServings += 1 }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(14)
                    }
                    
                    // Ingredients List
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Ingredients")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 10) {
                            ForEach(recipe.ingredients) { ingredient in
                                let ratio = Double(scaleServings) / Double(recipe.servings)
                                let scaledQuantity = ingredient.quantity * ratio
                                
                                HStack {
                                    HStack(spacing: 8) {
                                        Image(systemName: ingredient.groceryCategory.icon)
                                            .foregroundColor(.teal)
                                            .font(.system(size: 14))
                                        
                                        Text(ingredient.name)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(formatQuantity(scaledQuantity)) \(ingredient.unit)")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .background(Color.white.opacity(0.03))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Instructions
                    if !recipe.instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Instructions")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(recipe.instructions)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(6)
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
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            scaleServings = recipe.servings
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
                .foregroundColor(.green)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditRecipeView(recipe: recipe)
        }
    }
    
    private func markAsCooked() {
        recipe.timesCooked += 1
        try? modelContext.save()
        
        // Quick visual haptic feedback would happen here in a real app
    }
    
    private func formatQuantity(_ val: Double) -> String {
        if val == floor(val) {
            return String(format: "%.0f", val)
        } else {
            return String(format: "%.2f", val)
        }
    }
}
