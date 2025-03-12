import CoreGraphics
import CoreText
import Foundation
import UIKit

// Enum representing different font styles of the NunitoSans font
public enum NunitoSansFont: String, CaseIterable {
    case regular
    case semibold
    
    // Font name formatted with the font style
    var name: String {
        "NunitoSans7pt-\(rawValue.capitalized)"
    }
}

// FontManager is a utility class to handle the registration of custom fonts
public class FontManager {
    // Private helper function that registers a font with a specified font name and extension.
    // This function is used internally to register fonts in the app bundle
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        // Try to get the URL of the font file from the app bundle
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              // Create a font data provider from the font file URL
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              // Create a CGFont object from the font data provider
              let font = CGFont(fontDataProvider) else {
            
            // If font creation fails, the app will crash with an error message
            fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        
        // Error handling for font registration
        var error: Unmanaged<CFError>?
        
        // Register the font with the system's font manager
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    // Public function that registers all the NunitoSans fonts using the registerFont function
    public static func registerNunitoSans() {
        // Loop through all cases of the NunitoSansFont enum (regular and semibold)
        NunitoSansFont.allCases.forEach {
            // Register each font by calling the registerFont function with the font name and extension
            registerFont(bundle: .module, fontName: $0.name, fontExtension: "ttf")
        }
    }
}
