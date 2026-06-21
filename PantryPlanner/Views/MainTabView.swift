import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var currentWeekStart: Date = Date.defaultPlannerWeekStart()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeListView()
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
                .tag(0)
            
            MealPlannerView(currentWeekStart: $currentWeekStart)
                .tabItem {
                    Label("Planner", systemImage: "calendar")
                }
                .tag(1)
            
            GroceryListView(currentWeekStart: $currentWeekStart)
                .tabItem {
                    Label("Groceries", systemImage: "cart")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
        .accentColor(.green) // Sleek green accent theme throughout the app
        .onAppear {
            // Customize TabBar appearance if desired
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.08, green: 0.09, blue: 0.13, alpha: 1.0)
            
            // Unselected items color
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
            
            // Selected items color
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemGreen
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
