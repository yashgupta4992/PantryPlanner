import Foundation

public enum GroceryCategory: String, Codable, CaseIterable, Identifiable {
    case produce = "Produce"
    case dairy = "Dairy & Eggs"
    case meat = "Meat & Seafood"
    case pantry = "Pantry"
    case bakery = "Bakery"
    case frozen = "Frozen"
    case beverages = "Beverages"
    case snacks = "Snacks"
    case other = "Other"
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .produce: return "leaf.fill"
        case .dairy: return "drop.fill"
        case .meat: return "mouth.fill" // SF symbol representing food/meat or mouth
        case .pantry: return "archivebox.fill"
        case .bakery: return "stove"
        case .frozen: return "snowflake"
        case .beverages: return "cup.and.saucer.fill"
        case .snacks: return "fork.knife"
        case .other: return "questionmark.circle.fill"
        }
    }
}
