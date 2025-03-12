import Colors
import Components
import Coordinator
import Home
import NetworkMonitor
import SwiftUI

public struct SplashView: View {
    // Instance of SplashViewModel to manage state
    @StateObject private var viewModel = SplashViewModel()
    
    // Type alias defining the required coordinator protocols
    public typealias Protocols = ShowingNoInternetView & ShowingHomeView
    
    // Coordinator reference to handle navigation
    private let coordinator: Protocols?
    
    public init(coordinator: Protocols?) {
        self.coordinator = coordinator
    }
    
    public var body: some View {
        ZStack {
            Color.lemonYellow.ignoresSafeArea()
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 100)
        }
        // Handles navigation when a new route is added to the path
        .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .noInternet:
                // Navigates to "No Internet" screen, passing the retry binding
                NoInternetView(shouldRetry: $viewModel.shouldRetry)
            case .home:
                // Navigates to "Home" screen
                HomeView()
            }
        }
        // Observe changes to the @Published properties that will trigger the UI
        .onChange(of: viewModel.showNoInternetView) { _, newValue in
            if newValue {
                coordinator?.showNoInternetView()
            }
        }
        .onChange(of: viewModel.showApp) { _, newValue in
            if newValue {
                coordinator?.showHomeView()
            }
        }
    }
}
