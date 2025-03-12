import SwiftUI

// UsersView is a SwiftUI view that displays a list of users or a loading state if the data is being fetched
public struct UsersView: View {
    // Instance of UsersViewModel to manage state
    @StateObject private var viewModel = UsersViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Checks if the list of users is empty
            if viewModel.users.isEmpty {
                // Shows loading indicator if data is being fetched
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    // Shows a "No Users" screen when there are no users and no loading is happening
                    NoUsersView()
                }
            } else {
                // Displays a list of users if there are users to show
                List {
                    ForEach(viewModel.users, id: \.description) { user in
                        UserCardView(user: user)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                // When the last user in the list appears on screen, fetch more users
                                if user == viewModel.users.last {
                                    viewModel.fetchUsers()
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        // Fetch users when the view appears
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    UsersView()
}
