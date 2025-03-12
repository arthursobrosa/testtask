import SwiftUI

// Extension for the `Color` struct, adding custom colors from the module's asset file
public extension Color {
    static let black48 = Color("black48", bundle: .module)
    static let black60 = Color("black60", bundle: .module)
    static let black87 = Color("black87", bundle: .module)
    
    static let lightGrey = Color("lightGrey", bundle: .module)
    static let lightGrey2 = Color("lightGrey2", bundle: .module)
    static let softSilver = Color("softSilver", bundle: .module)
    
    static let oceanBlue = Color("oceanBlue", bundle: .module)
    static let darkOceanBlue = Color("darkOceanBlue", bundle: .module)
    
    static let redError = Color("redError", bundle: .module)
    
    static let lemonYellow = Color("lemonYellow", bundle: .module)
    static let goldenYellow = Color("goldenYellow", bundle: .module)
}
