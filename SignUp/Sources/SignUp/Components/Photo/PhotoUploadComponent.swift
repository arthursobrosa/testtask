import Components
import SwiftUI

// PhotoUploadComponent is a custom SwiftUI view used to allow users to upload a photo,
// with validation handling and error messages if necessary.
struct PhotoUploadComponent: View {
    // Tracks the validity of the photo upload
    @Binding private var isValid: Bool
    
    // Holds the error message related to photo upload (if any).
    @Binding var photoErrorText: String
    
    // Closure to handle the upload action when the button is tapped
    private let onTap: () -> Void
    
    init(isValid: Binding<Bool>, photoErrorText: Binding<String>, onTap: @escaping () -> Void) {
        self._isValid = isValid
        self._photoErrorText = photoErrorText
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // HStack for the photo upload header (text and button)
            HStack(alignment: .center, spacing: 0) {
                Text("Upload your photo")
                    .font(.nunito(size: 16, weight: .regular))
                    .foregroundStyle(isValid ? Color.black48 : Color.redError)
                    .padding(.trailing, 8)
                
                Spacer()
                
                Button("Upload") {
                    // Changes isValid state and calls closure
                    isValid = true
                    onTap()
                }
                .buttonStyle(ActionButtonStyle(.medium))
                .padding(.trailing, 8)
                .padding(.vertical, 4)
            }
            .padding(.leading, 16)
            .padding(.vertical, 4)
            
            // Rounded Rectangle in the back (with different color depending on isValid state)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        isValid ? Color.lightGrey2 : Color.redError,
                        lineWidth: 1
                    )
            )
            
            // Error message text (if any)
            Text(photoErrorText)
                .font(.nunito(size: 12, weight: .regular))
                .foregroundStyle(Color.redError)
                .padding(.leading, 16)
        }
    }
}

#Preview {
    @Previewable
    @State var isValid1: Bool = true
    
    @Previewable
    @State var isValid2: Bool = false
    
    VStack(spacing: 12) {
        PhotoUploadComponent(isValid: $isValid1, photoErrorText: .constant("Photo required")) {
            print("Button tapped")
        }
        
        PhotoUploadComponent(isValid: $isValid2, photoErrorText: .constant("Photo required")) {
            print("Button tapped")
        }
    }
    .padding(.horizontal, 16)
}
