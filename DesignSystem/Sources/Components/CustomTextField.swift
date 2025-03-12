import Colors
import Fonts
import SwiftUI

// Custom TextField view component to handle user input with validation and styling
public struct CustomTextField: View {
    // Properties for the text field.
    private let label: String
    @Binding private var input: String
    private let supportingText: String
    @Binding private var errorText: String
    @Binding private var isValid: Bool
    private let keyboardType: UIKeyboardType
    
    // Tracks the focus state of the text field
    @FocusState private var isFocused: Bool
    private var showTopLabel: Bool {
        // Shows the label on top when the text field is focused
        isFocused
    }
    
    // Enum to represent the different states of the text field
    enum FieldState {
        case unfocused // Field is not focused
        case focused   // Field is focused
        case invalid   // Field is invalid due to incorrect input
        
        // Label color based on field state
        var labelColor: Color {
            switch self {
            case .unfocused:
                Color.black60
            case .focused:
                Color.oceanBlue
            case .invalid:
                Color.redError
            }
        }
        
        // Border (rectangle) color based on field state
        var rectangleColor: Color {
            switch self {
            case .unfocused:
                Color.lightGrey2
            case .focused:
                Color.oceanBlue
            case .invalid:
                Color.redError
            }
        }
        
        // Border width based on field state
        var strokeWidth: Double {
            switch self {
            case .focused:
                2
            case .unfocused, .invalid:
                1
            }
        }
        
        // Bottom text color based on field state (valid or invalid)
        var bottomTextColor: Color {
            switch self {
            case .unfocused, .focused:
                Color.black60
            case .invalid:
                Color.redError
            }
        }
    }
    
    // Determines the current state of the field based on focus and validity
    private var state: FieldState {
        if isFocused {
            return .focused
        } else {
            if isValid {
                return .unfocused
            } else {
                return .invalid
            }
        }
    }
    
    public init(
        label: String,
        input: Binding<String>,
        supportingText: String = String(),
        errorText: Binding<String>,
        isValid: Binding<Bool>,
        keyboardType: UIKeyboardType
    ) {
        self.label = label
        self._input = input
        self.supportingText = supportingText
        self._errorText = errorText
        self._isValid = isValid
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // Label and TextField container
            VStack(alignment: .leading, spacing: 0) {
                // Top label shown only when the field is focused
                if showTopLabel {
                    Text(label)
                        .font(.nunito(size: 12, weight: .regular))
                        .foregroundStyle(state.labelColor)
                        .frame(height: 16)
                        .padding(.top, 8)
                }
                
                // Main TextField for input
                TextField(
                    "",
                    text: $input,
                    // Prompt is being used to change the placeholder's color and font
                    prompt:
                        Text(showTopLabel ? String() : label)
                        .font(.nunito(size: 16, weight: .regular))
                        .foregroundStyle(state.labelColor)
                )
                .keyboardType(keyboardType) // sets keyboard type based on passed argument
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .frame(height: 24)
                .padding(.top, showTopLabel ? 0 : 16)
                .padding(.bottom, showTopLabel ? 8 : 16)
                .font(.nunito(size: 16, weight: .regular)) // input color
                .foregroundStyle(Color.black87) // input font
                .focused($isFocused) // change focus
            }
            .padding(.leading, 16)
            .frame(maxWidth: .infinity)
            .background(
                // Rounded rectangle behind text field
                RoundedRectangle(cornerRadius: 4)
                    .stroke(state.rectangleColor, lineWidth: state.strokeWidth)
            )
            
            // Supporting or error text displayed below the text field
            Text(isValid ? supportingText : errorText)
                .font(.nunito(size: 12, weight: .regular))
                .foregroundStyle(state.bottomTextColor)
                .padding(.horizontal, 16)
                .padding(.top, 4)
        }
        .onChange(of: isFocused) { _, newValue in
            if newValue {
                // If the text field becomes focused, mark it as valid
                isValid = true
            }
        }
    }
}

#Preview {
    @Previewable
    @State var input: String = String()
    
    @Previewable
    @State var isValid: Bool = true
    
    CustomTextField(
        label: "Label",
        input: $input,
        supportingText: "Supporting Text",
        errorText: .constant("Error Text"),
        isValid: $isValid,
        keyboardType: .alphabet
    )
    .padding(.horizontal, 16)
}
