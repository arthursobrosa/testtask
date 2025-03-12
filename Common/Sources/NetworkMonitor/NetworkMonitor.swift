import Foundation
import Network

// NetworkMonitor class checks the network status and provides updates on connectivity status
public class NetworkMonitor: ObservableObject {
    // NWPathMonitor is used to monitor the network path (connection type, status, etc.)
    private var monitor: NWPathMonitor?
    
    // Dispatch queue to handle network monitoring in the background
    private let queue = DispatchQueue.global(qos: .background)
    
    // Notifies other parts of the app when the connection status changes
    @Published public var isConnected: Bool = false
    
    public init() {}
    
    // Starts monitoring the network connection status
    public func startMonitoring() {
        // Instance of NWPathMonitor to monitor network path changes
        monitor = NWPathMonitor()
        
        // Sets the pathUpdateHandler to handle changes in network status
        monitor?.pathUpdateHandler = { path in
            // Ensures updates to the connection status happen on the main thread
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                // Updates the isConnected property based on the network path status
                isConnected = path.status == .satisfied
            }
        }
        
        // Starts the monitor on the background queue
        monitor?.start(queue: queue)
    }
    
    // Stops monitoring the network connection
    public func stopMonitoring() {
        // Cancels the monitor to stop tracking network status
        monitor?.cancel()
        
        // Sets the monitor to nil after cancellation
        monitor = nil
    }
}
