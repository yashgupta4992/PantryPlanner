import Foundation
import SwiftData

@Model
public final class CustomGroceryItem {
    public var id: UUID
    public var name: String
    public var category: String
    public var isChecked: Bool
    public var weekStartDate: Date
    
    public init(id: UUID = UUID(), name: String, category: GroceryCategory = .other, isChecked: Bool = false, weekStartDate: Date = Date().startOfWeek()) {
        self.id = id
        self.name = name
        self.category = category.rawValue
        self.isChecked = isChecked
        self.weekStartDate = weekStartDate.startOfWeek()
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
