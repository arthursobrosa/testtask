import Foundation

public enum AppRoute: Hashable {
    // Represents the case when there's no internet connection.
    // This could be used to display a "No Internet" screen.
    case noInternet
    
    // Represents the home screen of the app.
    // This is the main screen the user sees after starting the app.
    case home
}
