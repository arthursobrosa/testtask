import Colors
import Fonts
import SwiftUI

// Custom button style that defines appearance based on button type
public struct ActionButtonStyle: ButtonStyle {
    // Environment property to check if the button is enabled
    @Environment(\.isEnabled) private var isEnabled
    
    // Enum defining button types with specific styles
    public enum ButtonType {
        case large
        case medium
        
        // Determines button width relative to screen size
        var width: Double {
            switch self {
            case .large:
                140
            case .medium:
                83
            }
        }
        
        // Defines vertical padding for different button sizes
        var verticalPadding: Double {
            switch self {
            case .large:
                12
            case .medium:
                8
            }
        }
        
        // Font size based on button type
        var fontSize: Double {
            switch self {
            case .large:
                18
            case .medium:
                16
            }
        }
        
        // Text color depending on button type
        var textColor: Color {
            switch self {
            case .large:
                Color.black87
            case .medium:
                Color.darkOceanBlue
            }
        }
        
        // Background color when the button is pressed
        var pressedBackColor: Color {
            switch self {
            case .large:
                Color.goldenYellow
            case .medium:
                Color.oceanBlue.opacity(0.1)
            }
        }
        
        // Default background color when not pressed
        var notPressedBackColor: Color {
            switch self {
            case .large:
                Color.lemonYellow
            case .medium:
                Color.clear
            }
        }
        
        // Background color when the button is disabled
        var disabledBackColor: Color {
            switch self {
            case .large:
                Color.softSilver
            case .medium:
                Color.clear
            }
        }
    }
    
    // Button type (large or medium) that determines styling
    private let type: ButtonType
    
    public init(_ type: ButtonType) {
        self.type = type
    }
    
    // Defines how the button looks in different states
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.nunito(size: type.fontSize, weight: .semibold))
            .foregroundStyle(isEnabled ? type.textColor : Color.black48)
            .padding(.vertical, type.verticalPadding)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        isEnabled ? (configuration.isPressed ? type.pressedBackColor : type.notPressedBackColor) : type.disabledBackColor
                    )
                    .frame(width: UIScreen.main.bounds.width * type.width / 360)
            )
    }
}

#Preview {
    Button("Button") {}
        .buttonStyle(ActionButtonStyle(.large))
    
    Button("Button") {}
        .buttonStyle(ActionButtonStyle(.large))
        .disabled(true)
    
    Button("Button") {}
        .buttonStyle(ActionButtonStyle(.medium))
    
    Button("Button") {}
        .buttonStyle(ActionButtonStyle(.medium))
        .disabled(true)
}
