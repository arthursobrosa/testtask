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

## External API
The application interacts with a REST API to fetch and register users.

[API Documentation](https://openapi_apidocs.abz.dev/frontend-test-assignment-v1)

### GET requests
- Endpoint: **/users**
  - Retrieves a paginated list of users.
  - Displays 6 users per request.
  - Loads the next 6 users when scrolling.
- Endpoint: **/positions**
  - Retrieves available user positions.
  - Used for displaying radio button options in the registration form.
- Endpoint: **/token**
    - Returns an authentication token required for making POST requests.
    - The token must be included in the request headers when registering a user.

### POST requests
- Endpoint: **/users**
  - Registers a new user.
  - Requires a valid authentication token.
  - Implements validation according to the API documentation.
  - After successful registration, the new user appears in the /users list.

## Architecture & Package Management
- **Architecture**: The project follows the **MVVM (Model-View-ViewModel)** architecture.
- **Package Management**: Uses **Swift Package Manager (SPM)** to manage dependencies and modularization.

## Configuration
There are no API keys or environment variables required for running the project.

## Building and Running the Application
1. Clone the repository from GitHub:
   ```sh
   git clone git@github.com:arthursobrosa/testtask.git
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


