# Testtask

## Overview
Testtask is an iOS application that fetches and displays a list of users from an API. Users can view details such as name, position, email, number, and photo. Additionally, the app provides functionality to create a new user.

## Project Structure
Testtask is modularized into six Swift packages:

- **Common**: Contains shared utilities, including:
  - `API` module: Handles API requests.
  - `Coordinator` module: Manages app navigation and routing.
  - `NetworkMonitor`: Checks for internet connectivity.
- **DesignSystem**: Defines the app's design language, including:
  - Custom fonts.
  - Custom colors.
  - Reusable UI components.
- **Splash**: Handles the splash screen logic.
- **Home**: Contains the main home screen, which includes a tab bar with two sections: Users and SignUp.
- **Users**: Displays the list of users retrieved from the API.
- **SignUp**: Manages user creation.

## Dependencies
Testtask uses the following Apple frameworks:
- **SwiftUI**: For creating the UI.
- **Network**: For monitoring internet connectivity.
- **Combine**: For handling asynchronous data streams.
- **CoreGraphics** and **CoreText**: For creating the custom fonts.

The project does not rely on third-party dependencies.

## Architecture & Package Management
- **Architecture**: The project follows the **MVVM (Model-View-ViewModel)** architecture.
- **Package Management**: Uses **Swift Package Manager (SPM)** to manage dependencies and modularization.

## Configuration
There are no API keys or environment variables required for running the project.

## Building and Running the Application
1. Clone the repository from GitHub:
   ```sh
   git clone <repository-url>
   ```
2. Open the project in Xcode:
   ```sh
   cd testtask
   open Testtask.xcodeproj
   ```
3. Select an iOS simulator or physical device.
4. Build and run the project (`Cmd + R`).

## Troubleshooting & Common Issues
- **Build errors?** Ensure you are using the latest Xcode version and have the correct iOS SDK installed.
- **Navigation issues?** Verify the `Coordinator` module is correctly handling the routes.

---


