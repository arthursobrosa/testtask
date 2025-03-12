//
//  TesttaskApp.swift
//  Testtask
//
//  Created by Arthur Sobrosa on 02/03/25.
//

import Fonts
import Splash
import SwiftUI

@main
struct TesttaskApp: App {
    // Coordinator instance
    @StateObject private var splashCoordinator = SplashCoordinator()
    
    init() {
        // Registering custom font
        FontManager.registerNunitoSans()
    }
    
    var body: some Scene {
        WindowGroup {
            // Create navigation and bind its path to the coordinator
            NavigationStack(path: $splashCoordinator.path) {
                // Create Splash passing the coordinator
                SplashView(coordinator: splashCoordinator)
            }
            .preferredColorScheme(.light)
        }
    }
}
