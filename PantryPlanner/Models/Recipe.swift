import Foundation
import SwiftData

@Model
public final class Recipe {
    public var id: UUID
    public var name: String
    public var servings: Int
    public var cookTimeMinutes: Int
    public var cuisine: String
    public var ingredients: [Ingredient]
    public var isFavourite: Bool
    public var timesCooked: Int
    public var instructions: String // Added to allow user to store recipe instructions
    
    public init(id: UUID = UUID(), name: String, servings: Int = 4, cookTimeMinutes: Int = 30, cuisine: String = "General", ingredients: [Ingredient] = [], isFavourite: Bool = false, timesCooked: Int = 0, instructions: String = "") {
        self.id = id
        self.name = name
        self.servings = servings
        self.cookTimeMinutes = cookTimeMinutes
        self.cuisine = cuisine
        self.ingredients = ingredients
        self.isFavourite = isFavourite
        self.timesCooked = timesCooked
        self.instructions = instructions
    }
}
