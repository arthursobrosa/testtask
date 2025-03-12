import SwiftUI

// PhotoPicker is a SwiftUI wrapper around UIImagePickerController
// to allow image picking from either the camera or photo library.
struct PhotoPicker: UIViewControllerRepresentable {
    // Binding to the selected image so that the parent view can use it
    @Binding private var selectedImage: UIImage?
    
    // The source type: camera or photo library
    private let sourceType: UIImagePickerController.SourceType
    
    init(selectedImage: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType) {
        self._selectedImage = selectedImage
        self.sourceType = sourceType
    }

    // Coordinator is a helper class to manage UIImagePickerControllerDelegate methods
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Reference to the parent PhotoPicker
        var parent: PhotoPicker

        init(parent: PhotoPicker) {
            self.parent = parent
        }

        // Called when an image is picked, assigns the selected image to the parent view's binding
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                // Pass the picked image back to the parent
                parent.selectedImage = image
            }

            // Dismiss the picker after image is selected
            picker.dismiss(animated: true)
        }

        // Called when the user cancels the picker, dismissing the picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    // Function to create and return the coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // Function to create the UIImagePickerController when the view is created
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        // Set the coordinator as the delegate
        picker.delegate = context.coordinator
        
        // Set the source type (camera or photo library)
        picker.sourceType = sourceType
        
        return picker
    }

    // Function to update the UIImagePickerController when the SwiftUI view changes
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
