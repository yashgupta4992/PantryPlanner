import Foundation
import SwiftData

@Model
public final class WeeklyPlan {
    public var id: UUID
    public var weekStartDate: Date
    
    @Relationship(deleteRule: .cascade, inverse: \DayPlan.weeklyPlan)
    public var days: [DayPlan]
    
    public init(id: UUID = UUID(), weekStartDate: Date = Date()) {
        self.id = id
        self.weekStartDate = weekStartDate.startOfWeek()
        self.days = []
    }
}

@Model
public final class DayPlan {
    public var id: UUID
    public var date: Date
    public var dayName: String // "Monday", "Tuesday", etc.
    
    public var weeklyPlan: WeeklyPlan?
    
    @Relationship(deleteRule: .nullify)
    public var meals: [Recipe]
    
    // Scale tracking: dictionary of recipe ID string to scaling factor (e.g. "uuid": 2.0)
    // SwiftData doesn't store Dictionary of [String: Double] easily without Codable wrap, 
    // so we can store scale factors as a JSON string, or just scale in memory.
    // Let's store serving overrides as a simple JSON string to persist custom servings.
    public var servingOverridesJSON: String = "{}"
    
    public init(id: UUID = UUID(), date: Date, dayName: String, meals: [Recipe] = []) {
        self.id = id
        self.date = date
        self.dayName = dayName
        self.meals = meals
    }
    
    public func getServingsOverride(for recipeId: UUID) -> Int? {
        guard let data = servingOverridesJSON.data(using: .utf8),
              let dict = try? JSONDecoder().decode([String: Int].self, from: data) else {
            return nil
        }
        return dict[recipeId.uuidString]
    }
    
    public func setServingsOverride(for recipeId: UUID, servings: Int?) {
        guard let data = servingOverridesJSON.data(using: .utf8) else {
            return
        }
        var dict = (try? JSONDecoder().decode([String: Int].self, from: data)) ?? [String: Int]()
        if let servings = servings {
            dict[recipeId.uuidString] = servings
        } else {
            dict.removeValue(forKey: recipeId.uuidString)
        }
        if let newData = try? JSONEncoder().encode(dict),
           let jsonStr = String(data: newData, encoding: .utf8) {
            servingOverridesJSON = jsonStr
        }
    }
}

extension Date {
    public func startOfWeek() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = 2 // 2 corresponds to Monday
        return calendar.date(from: components) ?? self
    }
    
    public func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}
