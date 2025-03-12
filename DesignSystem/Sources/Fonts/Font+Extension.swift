import SwiftUI

// Extension to the Font struct, adding a custom method for the NunitoSans font
public extension Font {
    static func nunito(size: Double, weight: NunitoSansFont) -> Font {
        Font.custom(weight.name, size: size)
    }
}
