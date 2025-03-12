import Combine
import Foundation
import NetworkMonitor

// ViewModel for the Splash screen, handling network status and app launch logic
class SplashViewModel: ObservableObject {
    // Instance of NetworkMonitor to track connectivity
    private let networkMonitor = NetworkMonitor()
    
    // Flag to check if the minimum splash time has passed
    private var isTimeReached: Bool = false
    
    // Published properties to trigger UI updates
    @Published var showNoInternetView: Bool = false
    @Published var shouldRetry: Bool = false
    @Published var showApp: Bool = false
    
    // Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setNetworkMonitor()
        setPublishers()
    }
    
    // Starts monitoring connection after a 2-second delay
    private func setNetworkMonitor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            
            isTimeReached = true
            networkMonitor.startMonitoring()
        }
    }
    
    // Sets up publishers to react to network status and retry actions
    private func setPublishers() {
        setIsConnectedPublisher()
        setShouldRetryPublisher()
    }
    
    // Observes network connectivity changes
    private func setIsConnectedPublisher() {
        networkMonitor.$isConnected
            .sink { [weak self] isConnected in
                guard let self,
                      isTimeReached else { return } // Ensures splash delay is respected
                
                // Updates UI state based on connection status
                showNoInternetView = !isConnected
                showApp = isConnected
                
                // Stops monitoring if the device is offline
                // So the user can tap the "try again" button inside "No Internet" screen
                if !isConnected {
                    networkMonitor.stopMonitoring()
                }
            }
            .store(in: &cancellables)
    }
   
    // Observes retry attempts and restarts network monitoring if needed
    private func setShouldRetryPublisher() {
        $shouldRetry
            .sink { [weak self] shouldRetry in
                guard let self,
                      shouldRetry else { return }
                
                networkMonitor.startMonitoring()
            }
            .store(in: &cancellables)
    }
}
