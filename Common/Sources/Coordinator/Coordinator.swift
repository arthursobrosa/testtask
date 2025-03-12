import SwiftUI

// Coordinator protocol that adopts ObservableObject to manage navigation state
public protocol Coordinator: ObservableObject {
    // A property that holds the navigation path (used to control the navigation stack)
    var path: NavigationPath { get set }
    
    // A function to handle the "pop" action, i.e., go back to the previous screen
    func pop()
}
