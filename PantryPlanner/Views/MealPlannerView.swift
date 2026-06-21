import SwiftUI
import SwiftData

struct MealPlannerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeeklyPlan.weekStartDate) private var allPlans: [WeeklyPlan]
    @Query(sort: \Recipe.name) private var allRecipes: [Recipe]
    
    @Binding var currentWeekStart: Date
    @State private var activePlan: WeeklyPlan? = nil
    @State private var selectedDayForAddingRecipe: DayPlan? = nil
    
    var weekRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startStr = formatter.string(from: currentWeekStart)
        let endStr = formatter.string(from: currentWeekStart.adding(days: 6))
        return "\(startStr) – \(endStr)"
    }
    
    var sortedDays: [DayPlan] {
        guard let activePlan = activePlan else { return [] }
        return activePlan.days.sorted(by: { $0.date < $1.date })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Week Selector Header
                    HStack {
                        Button(action: { changeWeek(byDays: -7) }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        Text(weekRangeString)
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { changeWeek(byDays: 7) }) {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    
                    if activePlan == nil {
                        Spacer()
                        ProgressView()
                            .tint(.green)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(sortedDays) { day in
                                    DayPlanRow(
                                        day: day,
                                        onAddRecipe: {
                                            selectedDayForAddingRecipe = day
                                        },
                                        onRemoveRecipe: { recipe in
                                            removeRecipe(recipe, from: day)
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Meal Planner")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: copyLastWeekPlan) {
                        Label("Copy Last Week", systemImage: "doc.on.doc")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: resetCurrentWeekPlan) {
                        Label("Reset Week", systemImage: "arrow.counterclockwise")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(item: $selectedDayForAddingRecipe) { day in
                RecipeSelectorSheet(day: day, allRecipes: allRecipes) { recipe in
                    addRecipe(recipe, to: day)
                }
            }
            .onAppear {
                loadOrCreatePlan()
            }
            .onChange(of: currentWeekStart) { _, _ in
                loadOrCreatePlan()
            }
        }
    }
    
    private func changeWeek(byDays days: Int) {
        currentWeekStart = currentWeekStart.adding(days: days)
    }
    
    private func loadOrCreatePlan() {
        let targetDate = currentWeekStart.startOfWeek()
        if let existing = allPlans.first(where: { Calendar.current.isDate($0.weekStartDate, inSameDayAs: targetDate) }) {
            self.activePlan = existing
        } else {
            let newPlan = WeeklyPlan(weekStartDate: targetDate)
            modelContext.insert(newPlan)
            
            let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
            var daysList: [DayPlan] = []
            for i in 0..<7 {
                let dayDate = targetDate.adding(days: i)
                let dayPlan = DayPlan(date: dayDate, dayName: dayNames[i])
                modelContext.insert(dayPlan)
                dayPlan.weeklyPlan = newPlan
                daysList.append(dayPlan)
            }
            newPlan.days = daysList
            try? modelContext.save()
            self.activePlan = newPlan
        }
    }
    
    private func addRecipe(_ recipe: Recipe, to day: DayPlan) {
        if !day.meals.contains(where: { $0.id == recipe.id }) {
            day.meals.append(recipe)
            // Default serving override to the recipe's default servings
            day.setServingsOverride(for: recipe.id, servings: recipe.servings)
            try? modelContext.save()
        }
    }
    
    private func removeRecipe(_ recipe: Recipe, from day: DayPlan) {
        day.meals.removeAll { $0.id == recipe.id }
        day.setServingsOverride(for: recipe.id, servings: nil)
        try? modelContext.save()
    }
    
    private func copyLastWeekPlan() {
        guard let activePlan = activePlan else { return }
        let lastWeekDate = currentWeekStart.adding(days: -7)
        
        guard let lastWeekPlan = allPlans.first(where: { Calendar.current.isDate($0.weekStartDate, inSameDayAs: lastWeekDate) }) else {
            return
        }
        
        let activeDays = activePlan.days.sorted(by: { $0.date < $1.date })
        let lastWeekDays = lastWeekPlan.days.sorted(by: { $0.date < $1.date })
        
        for i in 0..<min(activeDays.count, lastWeekDays.count) {
            activeDays[i].meals = lastWeekDays[i].meals
            activeDays[i].servingOverridesJSON = lastWeekDays[i].servingOverridesJSON
        }
        
        try? modelContext.save()
        loadOrCreatePlan() // Force UI reload
    }
    
    private func resetCurrentWeekPlan() {
        guard let activePlan = activePlan else { return }
        for day in activePlan.days {
            day.meals = []
            day.servingOverridesJSON = "{}"
        }
        try? modelContext.save()
        loadOrCreatePlan() // Force UI reload
    }
}

// Helper to make sheet item conforming to Identifiable
extension DayPlan: Identifiable {}

// Row View for each day in the planner grid
struct DayPlanRow: View {
    @Bindable var day: DayPlan
    var onAddRecipe: () -> Void
    var onRemoveRecipe: (Recipe) -> Void
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: day.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Day title header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(day.dayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: onAddRecipe) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Add Meal")
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.12))
                    .cornerRadius(8)
                }
            }
            
            // Meals list
            if day.meals.isEmpty {
                Text("No meals planned")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.vertical, 4)
            } else {
                VStack(spacing: 8) {
                    ForEach(day.meals) { recipe in
                        let servings = day.getServingsOverride(for: recipe.id) ?? recipe.servings
                        
                        HStack {
                            Text(recipe.name)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            // Servings control
                            HStack(spacing: 8) {
                                Button(action: {
                                    if servings > 1 {
                                        day.setServingsOverride(for: recipe.id, servings: servings - 1)
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(servings)p")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.teal)
                                    .frame(width: 25)
                                
                                Button(action: {
                                    day.setServingsOverride(for: recipe.id, servings: servings + 1)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(action: { onRemoveRecipe(recipe) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red.opacity(0.8))
                                    .padding(.leading, 8)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
}

// Sheet view to select a recipe from the library
struct RecipeSelectorSheet: View {
    @Environment(\.dismiss) private var dismiss
    var day: DayPlan
    var allRecipes: [Recipe]
    var onSelect: (Recipe) -> Void
    
    @State private var searchText = ""
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return allRecipes
        }
        return allRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()
                
                VStack {
                    SearchBar(text: $searchText, placeholder: "Search recipes...")
                    
                    if filteredRecipes.isEmpty {
                        Spacer()
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No recipes available")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Text("Add recipes in the Recipe Library first!")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        List(filteredRecipes) { recipe in
                            Button(action: {
                                onSelect(recipe)
                                dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("\(recipe.cuisine) • \(recipe.cookTimeMinutes)m")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.green)
                                        .font(.title3)
                                }
                            }
                            .listRowBackground(Color.white.opacity(0.03))
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Select meal for \(day.dayName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
        }
    }
}

// Standalone Search Bar View
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
