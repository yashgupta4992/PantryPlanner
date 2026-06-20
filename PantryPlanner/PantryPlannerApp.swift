import SwiftUI
import SwiftData

@main
struct PantryPlannerApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                FamilyProfile.self,
                Recipe.self,
                WeeklyPlan.self,
                DayPlan.self,
                CustomGroceryItem.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(container)
    }
}

struct AppRootView: View {
    @Query private var profiles: [FamilyProfile]
    @State private var onboardingCompleted: Bool = false
    
    var body: some View {
        Group {
            if profiles.isEmpty && !onboardingCompleted {
                OnboardingView(onboardingCompleted: $onboardingCompleted)
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark) // Establish the premium dark mode default look
    }
}
