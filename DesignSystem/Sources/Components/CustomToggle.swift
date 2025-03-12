import SwiftUI

// CustomToggle is a custom SwiftUI component that creates a toggle switch with animation and color change based on its state
public struct CustomToggle: View {
    // The binding for the checked state of the toggle
    @Binding private var isChecked: Bool
    
    // State to track whether the toggle is being pressed or not
    @State private var isPressed: Bool = false
    
    // Enum representing the different states of the toggle,
    // including whether it's checked or unchecked, and whether it's pressed
    enum ToggleState {
        case checkedAndNotPressed
        case checkedAndPressed
        case uncheckedAndNotPressed
        case uncheckedAndPressed
        
        // Color of the large circle based on the state
        var largeCircleColor: Color {
            switch self {
            case .checkedAndPressed, .uncheckedAndPressed:
                Color.oceanBlue.opacity(0.1)
            default:
                Color.clear
            }
        }
        
        // Color of the medium circle based on the state
        var mediumCircleColor: Color {
            switch self {
            case .checkedAndNotPressed, .checkedAndPressed:
                Color.oceanBlue
            default:
                Color.white
            }
        }
        
        // Stroke width for the medium circle based on the state
        var mediumCircleStroke: Double {
            switch self {
            case .uncheckedAndNotPressed, .uncheckedAndPressed:
                1
            default:
                0
            }
        }
    }
    
    // Compute the current state of the toggle based on the `isChecked` and `isPressed` values
    private var state: ToggleState {
        if isChecked {
            if isPressed {
                return .checkedAndPressed
            } else {
                return .checkedAndNotPressed
            }
        } else {
            if isPressed {
                return .uncheckedAndPressed
            } else {
                return .uncheckedAndNotPressed
            }
        }
    }
    
    public init(isChecked: Binding<Bool>) {
        self._isChecked = isChecked
    }
    
    public var body: some View {
        // The main circle that represents the toggle's background
        Circle()
            .foregroundStyle(state.largeCircleColor)
            .overlay {
                GeometryReader { geometry in
                    // GeometryReader is used to size and position the inner circles based on the parent circle's size
                    Circle()
                        .foregroundStyle(state.mediumCircleColor)
                        .frame(width: geometry.size.width * 14/48)
                    
                        // Position the circle in the center
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        .overlay {
                            // The stroke (border) around the medium circle, with varying thickness based on the state
                            Circle()
                                .stroke(
                                    Color.lightGrey2,
                                    lineWidth: geometry.size.width * state.mediumCircleStroke / 48
                                )
                                .frame(width: geometry.size.width * 14/48)
                            
                            // The small white circle in the center of the toggle button
                            Circle()
                                .foregroundStyle(.white)
                                .frame(width: geometry.size.width * 6/48)
                        }
                }
            }
            // Gesture recognizer to detect tapping and toggle the state
            .gesture(
                // Detect any drag gesture with no minimum distance (tap)
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        // Set the pressed state to true when dragging starts
                        isPressed = true
                    }
                    .onEnded { _ in
                        // Reset the pressed state when dragging ends
                        isPressed = false
                        
                        // Toggle the `isChecked` state
                        isChecked.toggle()
                    }
            )
            // Apply animation to smooth transitions between states
            .animation(.easeInOut(duration: 0.2), value: isChecked)
    }
}

#Preview {
    @Previewable
    @State var isChecked: Bool = true
    
    GeometryReader { geometry in
        CustomToggle(isChecked: $isChecked)
            .frame(width: geometry.size.width * 48/360)
    }
}
