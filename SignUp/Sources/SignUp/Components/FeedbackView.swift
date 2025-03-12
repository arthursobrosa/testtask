import Colors
import Components
import Fonts
import SwiftUI

// FeedbackView is a view that shows feedback to the user after an action,
// such as a registration success or failure.
struct FeedbackView: View {
    // Dismiss action to close the current view.
    @Environment(\.dismiss) private var dismiss
    
    // Enum to define the possible statuses of feedback (success or failure).
    enum Status {
        case success
        case failure
        
        // Image to show for each status
        var image: Image {
            switch self {
            case .success:
                Image(.registerSuccess)
            case .failure:
                Image(.registerFailure)
            }
        }
        
        // Description text to show for each status
        var description: String {
            switch self {
            case .success:
                "User successfully registered"
            case .failure:
                "Email or phone already registered"
            }
        }
        
        // Button text to display for each status
        var buttonText: String {
            switch self {
            case .success:
                "Got it"
            case .failure:
                "Try again"
            }
        }
    }
    
    // The status to display, passed in during initialization
    private let status: Status
    
    init(status: Status) {
        self.status = status
    }
    
    var body: some View {
        VStack(spacing: 24) {
            status.image
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 80)
            
            Text(status.description)
                .font(.nunito(size: 20, weight: .regular))
                .foregroundStyle(Color.black87)
                .padding(.horizontal, 16)
            
            Button(status.buttonText) {
                // Dismiss the view when the button is pressed.
                dismiss()
            }
            .buttonStyle(ActionButtonStyle(.large))
        }
    }
}

#Preview {
    FeedbackView(status: .success)
}

#Preview {
    FeedbackView(status: .failure)
}
