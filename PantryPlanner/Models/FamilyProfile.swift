import Foundation
import SwiftData

@Model
public final class FamilyProfile {
    public var id: UUID
    public var name: String
    public var size: Int
    public var dietaryPreferences: [String]
    public var cuisinePreferences: [String]
    
    public init(id: UUID = UUID(), name: String = "My Family", size: Int = 2, dietaryPreferences: [String] = [], cuisinePreferences: [String] = []) {
        self.id = id
        self.name = name
        self.size = size
        self.dietaryPreferences = dietaryPreferences
        self.cuisinePreferences = cuisinePreferences
    }
}
