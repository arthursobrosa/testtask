import Components
import Coordinator
import SignUp
import SwiftUI
import Users

// Main Home View within a Tab Bar
public struct HomeView: View {
    // Tracks current selected tab
    @State private var selectedTab = 0
    
    // Available tabs with associated icons and labels
    private let tabs: [CustomTabItem] = [
        CustomTabItem(tag: 0, title: Text("Users"), image: Image(systemName: "person.3.sequence.fill")),
        CustomTabItem(tag: 1, title: Text("Sign up"), image: Image(systemName: "person.crop.circle.badge.plus"))
    ]
    
    public init() {}
    
    public var body: some View {
        CustomTabView(tabs: tabs, selection: $selectedTab) {
            ZStack {
                // leftmost tab shows "Users" screen
                // rightmost tab shows "Sign up" screen
                if selectedTab == 0 {
                    UsersView()
                } else {
                    SignUpView()
                }
            }
        }
        .navigationBarBackButtonHidden() // Hides back button so the user cannot go back to splash
    }
}
