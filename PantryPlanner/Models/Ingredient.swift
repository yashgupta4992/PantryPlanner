import Foundation

public struct Ingredient: Codable, Hashable, Identifiable {
    public var id: UUID
    public var name: String
    public var quantity: Double
    public var unit: String   // e.g., "g", "ml", "cups", "items", "tbsp", "tsp"
    public var category: String // Store rawValue of GroceryCategory
    
    public init(id: UUID = UUID(), name: String, quantity: Double, unit: String, category: GroceryCategory) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.category = category.rawValue
    }
    
    public var groceryCategory: GroceryCategory {
        get {
            GroceryCategory(rawValue: category) ?? .other
        }
        set {
            category = newValue.rawValue
        }
    }
}
