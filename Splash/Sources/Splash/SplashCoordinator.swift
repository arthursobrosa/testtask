import Coordinator
import Home
import SwiftUI

// Class responsible for splash navigation
// ShowingNoInternetView and ShowingHomeView are protocols that implement methods inside SplashCoordinator
public class SplashCoordinator: Coordinator, ShowingNoInternetView, ShowingHomeView {
    // Property to track the navigation path
    @Published public var path: NavigationPath
    
    public init(path: NavigationPath = NavigationPath()) {
        self.path = path
    }
    
    // Method to navigate to "No Internet" screen
    public func showNoInternetView() {
        path.append(AppRoute.noInternet)
    }
    
    // Method to navigate to "Home" screen
    public func showHomeView() {
        if !path.isEmpty {
            pop()
        }
        
        path.append(AppRoute.home)
    }
    
    // Method to remove last screen from navigation path
    public func pop() {
        path.removeLast()
    }
}
