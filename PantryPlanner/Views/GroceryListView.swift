import SwiftUI
import SwiftData

struct GroceryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allPlans: [WeeklyPlan]
    @Query private var customItems: [CustomGroceryItem]
    
    @State private var currentWeekStart: Date = Date().startOfWeek()
    
    // In-memory checked state for dynamically aggregated recipe ingredients
    @State private var checkedRecipeIngredients: Set<String> = []
    
    // Add custom item form state
    @State private var newCustomName: String = ""
    @State private var newCustomCategory: GroceryCategory = .other
    @State private var showingAddSection = false
    
    var activePlan: WeeklyPlan? {
        allPlans.first(where: { Calendar.current.isDate($0.weekStartDate, inSameDayAs: currentWeekStart) })
    }
    
    // Consolidated recipe ingredients
    var consolidatedIngredients: [ConsolidatedIngredient] {
        guard let plan = activePlan else { return [] }
        var dict: [String: ConsolidatedIngredient] = [:]
        
        for day in plan.days {
            for recipe in day.meals {
                let actualServings = day.getServingsOverride(for: recipe.id) ?? recipe.servings
                let ratio = Double(actualServings) / Double(recipe.servings)
                
                for ing in recipe.ingredients {
                    let key = "\(ing.name.lowercased())-\(ing.unit.lowercased())"
                    let scaledQty = ing.quantity * ratio
                    
                    if let existing = dict[key] {
                        dict[key] = ConsolidatedIngredient(
                            name: existing.name, // Keep casing of first seen
                            quantity: existing.quantity + scaledQty,
                            unit: existing.unit,
                            category: existing.category
                        )
                    } else {
                        dict[key] = ConsolidatedIngredient(
                            name: ing.name,
                            quantity: scaledQty,
                            unit: ing.unit,
                            category: ing.groceryCategory
                        )
                    }
                }
            }
        }
        
        return Array(dict.values).sorted(by: { $0.name < $1.name })
    }
    
    // Custom items for the current week
    var currentCustomItems: [CustomGroceryItem] {
        customItems.filter { Calendar.current.isDate($0.weekStartDate, inSameDayAs: currentWeekStart) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Week range info bar
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.green)
                        Text("Grocery List for \(weekRangeString)")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.03))
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            // Custom Item Add Section
                            VStack(alignment: .leading, spacing: 12) {
                                Button(action: { withAnimation { showingAddSection.toggle() } }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.green)
                                        Text("Add custom item (Milk, Soap...)")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.9))
                                        Spacer()
                                        Image(systemName: showingAddSection ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                }
                                
                                if showingAddSection {
                                    VStack(spacing: 12) {
                                        TextField("Item name...", text: $newCustomName)
                                            .padding()
                                            .background(Color.white.opacity(0.06))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        
                                        HStack {
                                            Picker("Category", selection: $newCustomCategory) {
                                                ForEach(GroceryCategory.allCases) { cat in
                                                    Text(cat.rawValue).tag(cat)
                                                }
                                            }
                                            .tint(.green)
                                            .padding(.horizontal)
                                            .padding(.vertical, 6)
                                            .background(Color.white.opacity(0.06))
                                            .cornerRadius(10)
                                            
                                            Spacer()
                                            
                                            Button(action: addCustomItem) {
                                                Text("Add to List")
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 10)
                                                    .background(Color.green)
                                                    .cornerRadius(10)
                                            }
                                            .disabled(newCustomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                            .opacity(newCustomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                                        }
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.03))
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                            
                            if consolidatedIngredients.isEmpty && currentCustomItems.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "cart.badge.questionmark")
                                        .font(.system(size: 48))
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(.top, 60)
                                    Text("Your list is empty")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("Plan some meals in the Planner tab, or add custom items here, to generate your grocery list.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30)
                                }
                            } else {
                                // Group by supermarket section
                                let groupedUnchecked = getGroupedUncheckedItems()
                                let checkedItemsList = getCheckedItems()
                                
                                // Unchecked items listed by Category
                                ForEach(GroceryCategory.allCases) { cat in
                                    if let items = groupedUnchecked[cat], !items.isEmpty {
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Image(systemName: cat.icon)
                                                    .foregroundColor(.teal)
                                                Text(cat.rawValue)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 4)
                                            
                                            VStack(spacing: 8) {
                                                ForEach(items, id: \.self) { item in
                                                    GroceryItemRow(
                                                        name: item.name,
                                                        details: item.details,
                                                        isChecked: false,
                                                        onToggle: {
                                                            toggleItem(item)
                                                        }
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // Collapsible Checked items section
                                if !checkedItemsList.isEmpty {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Divider()
                                            .background(Color.white.opacity(0.1))
                                            .padding(.vertical, 10)
                                        
                                        Text("Completed (\(checkedItemsList.count))")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 4)
                                        
                                        VStack(spacing: 8) {
                                            ForEach(checkedItemsList, id: \.self) { item in
                                                GroceryItemRow(
                                                    name: item.name,
                                                    details: item.details,
                                                    isChecked: true,
                                                    onToggle: {
                                                        toggleItem(item)
                                                    }
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !checkedRecipeIngredients.isEmpty || currentCustomItems.contains(where: { $0.isChecked }) {
                        Button("Reset List") {
                            resetCheckedState()
                        }
                        .foregroundColor(.green)
                    }
                }
            }
            .onAppear {
                currentWeekStart = Date().startOfWeek()
            }
        }
    }
    
    var weekRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startStr = formatter.string(from: currentWeekStart)
        let endStr = formatter.string(from: currentWeekStart.adding(days: 6))
        return "\(startStr) – \(endStr)"
    }
    
    // Add a manual item to the database
    private func addCustomItem() {
        let cleanName = newCustomName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        let newItem = CustomGroceryItem(
            name: cleanName,
            category: newCustomCategory,
            isChecked: false,
            weekStartDate: currentWeekStart
        )
        
        modelContext.insert(newItem)
        try? modelContext.save()
        
        newCustomName = ""
        showingAddSection = false
    }
    
    // Helper to represent both recipe ingredients and custom list items uniformly in UI
    struct DisplayGroceryItem: Hashable {
        let id: String // name-unit or uuid string
        let name: String
        let details: String
        let category: GroceryCategory
        let isCustom: Bool
    }
    
    private func getGroupedUncheckedItems() -> [GroceryCategory: [DisplayGroceryItem]] {
        var grouped: [GroceryCategory: [DisplayGroceryItem]] = [:]
        
        // Add recipe items
        for ing in consolidatedIngredients {
            let itemId = ing.id
            if !checkedRecipeIngredients.contains(itemId) {
                let display = DisplayGroceryItem(
                    id: itemId,
                    name: ing.name,
                    details: "\(formatQuantity(ing.quantity)) \(ing.unit)",
                    category: ing.category,
                    isCustom: false
                )
                grouped[ing.category, default: []].append(display)
            }
        }
        
        // Add custom items
        for item in currentCustomItems {
            if !item.isChecked {
                let display = DisplayGroceryItem(
                    id: item.id.uuidString,
                    name: item.name,
                    details: "",
                    category: item.groceryCategory,
                    isCustom: true
                )
                grouped[item.groceryCategory, default: []].append(display)
            }
        }
        
        return grouped
    }
    
    private func getCheckedItems() -> [DisplayGroceryItem] {
        var checked: [DisplayGroceryItem] = []
        
        // Add recipe items
        for ing in consolidatedIngredients {
            let itemId = ing.id
            if checkedRecipeIngredients.contains(itemId) {
                checked.append(DisplayGroceryItem(
                    id: itemId,
                    name: ing.name,
                    details: "\(formatQuantity(ing.quantity)) \(ing.unit)",
                    category: ing.category,
                    isCustom: false
                ))
            }
        }
        
        // Add custom items
        for item in currentCustomItems {
            if item.isChecked {
                checked.append(DisplayGroceryItem(
                    id: item.id.uuidString,
                    name: item.name,
                    details: "",
                    category: item.groceryCategory,
                    isCustom: true
                ))
            }
        }
        
        return checked.sorted(by: { $0.name < $1.name })
    }
    
    private func toggleItem(_ item: DisplayGroceryItem) {
        if item.isCustom {
            // Update model in database
            if let custom = currentCustomItems.first(where: { $0.id.uuidString == item.id }) {
                custom.isChecked.toggle()
                try? modelContext.save()
            }
        } else {
            // Update in-memory checked state
            if checkedRecipeIngredients.contains(item.id) {
                checkedRecipeIngredients.remove(item.id)
            } else {
                checkedRecipeIngredients.insert(item.id)
            }
        }
    }
    
    private func resetCheckedState() {
        checkedRecipeIngredients.removeAll()
        for item in currentCustomItems {
            item.isChecked = false
        }
        try? modelContext.save()
    }
    
    private func formatQuantity(_ val: Double) -> String {
        if val == floor(val) {
            return String(format: "%.0f", val)
        } else {
            return String(format: "%.1f", val)
        }
    }
}

// Struct representing recipe ingredients that are consolidated
struct ConsolidatedIngredient: Identifiable, Hashable {
    var id: String { "\(name.lowercased())-\(unit.lowercased())" }
    var name: String
    var quantity: Double
    var unit: String
    var category: GroceryCategory
}

// Subview for one item row in the shopping list
struct GroceryItemRow: View {
    let name: String
    let details: String
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .green : .gray)
                    .font(.title3)
                
                Text(name)
                    .foregroundColor(isChecked ? .gray : .white)
                    .strikethrough(isChecked, color: .gray)
                    .font(.subheadline)
                
                Spacer()
                
                if !details.isEmpty {
                    Text(details)
                        .foregroundColor(.gray)
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .padding()
            .background(Color.white.opacity(isChecked ? 0.01 : 0.04))
            .cornerRadius(10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
