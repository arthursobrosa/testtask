import API
import Foundation

// ViewModel for managing the users data
class UsersViewModel: ObservableObject {
    // Instance of APIService to handle network requests
    private let networkService: APIService = APIService()
    
    // Property to store the list of users, triggers UI updates
    @Published var users: [UserModel] = []
    
    // Tracks the current page of users list
    private var currentPage: Int = 1
    
    // Property to track loading state, used for UI updates
    @Published var isLoading: Bool = false
    
    // Flag to determine if more users should be loaded
    private var shouldLoadUsers: Bool = true
    
    // Fetch users from the network with async/await in a task
    @MainActor
    func fetchUsers() {
        // Ensure we are not already loading users and that we should load more
        guard !isLoading, shouldLoadUsers else { return }
        
        // Set loading state to true
        isLoading = true
        
        // Perform network request asynchronously
        Task {
            do {
                // Fetch users for the current page
                let newUsers = try await networkService.fetchUsers(page: currentPage)
                
                // Append the fetched users to the existing list
                users.append(contentsOf: newUsers)
                
                // Increment current page
                currentPage += 1
            } catch APIServiceError.invalidStatusCode(let statusCode) {
                // Handles specific error case for 404 status code (no more users to load)
                if statusCode == 404 {
                    shouldLoadUsers = false
                }
            } catch let error {
                // General error handling, printing error message to the console
                print("error fetching users at page \(currentPage): \(error.localizedDescription)")
            }
            
            // Reset loading state once the task is complete
            isLoading = false
        }
    }
}
