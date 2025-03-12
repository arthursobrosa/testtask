import Components
import SwiftUI

// SignUpView is a SwiftUI view that displays all the fields necessary to create a user
public struct SignUpView: View {
    // Instance of SignUpViewModel to manage state
    @StateObject private var viewModel = SignUpViewModel()
    
    // Manages the visibility of the confirmation dialog for photo selection
    @State private var showConfirmationDialog: Bool = false
    
    // Manages the image picker source type (camera or gallery)
    @State private var pickerSourceType: UIImagePickerController.SourceType?
    
    // Stores selected photo
    @State private var selectedImage: UIImage?
    
    // Manages the visibility of the image picker sheet
    @State private var showPicker: Bool = false
    
    public init() {}
    
    public var body: some View {
        // Shows a progress indicator while the viewModel is loading
        if viewModel.isLoading {
            ProgressView()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Grouping for text fields: name, email, and phone input
                    VStack(spacing: 12) {
                        CustomTextField(
                            label: "Your name",
                            input: $viewModel.nameInput,
                            errorText: $viewModel.nameErrorText,
                            isValid: $viewModel.isNameValid,
                            keyboardType: .alphabet
                        )
                        
                        CustomTextField(
                            label: "Email",
                            input: $viewModel.emailInput,
                            errorText: $viewModel.emailErrorText,
                            isValid: $viewModel.isEmailValid,
                            keyboardType: .emailAddress
                        )
                        
                        CustomTextField(
                            label: "Phone",
                            input: $viewModel.phoneInput,
                            supportingText: "+38 (0XX) XXX - XX - XX",
                            errorText: $viewModel.phoneErrorText,
                            isValid: $viewModel.isPhoneValid,
                            keyboardType: .numberPad
                        )
                        // Handles phone input change to format phone number correctly
                        .onChange(of: viewModel.phoneInput) { oldValue, newValue in
                            guard newValue > oldValue else { return }
                            
                            viewModel.formatPhoneInput()
                        }
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 4)
                    
                    // Grouping for position selection
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Select your position")
                            .font(.nunito(size: 18, weight: .regular))
                            .foregroundStyle(Color.black87)
                            .padding(.bottom, 12)
                        
                        // For each position, display a toggle to select it
                        ForEach(Array(viewModel.positions.enumerated()), id: \.element) { index, position in
                            HStack(spacing: 8) {
                                // Toggle to the left
                                CustomToggle(
                                    // Property to manage toggle state
                                    isChecked: Binding(
                                        get: {
                                            // If current position is equal to the selected position
                                            // then toggle is on
                                            index == viewModel.selectedPositionIndex
                                        },
                                        set: { isSelected in
                                            // When the toggle is selected by the user,
                                            // the current position is changed
                                            viewModel.selectedPositionIndex = index
                                        }
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width * 48/360)
                                
                                // Label to right
                                Text(position.name)
                                    .font(.nunito(size: 16, weight: .regular))
                                    .foregroundStyle(Color.black87)
                            }
                        }
                    }
                    
                    // Component for uploading a photo
                    PhotoUploadComponent(isValid: $viewModel.isPhotoValid, photoErrorText: $viewModel.photoErrorText) {
                        showConfirmationDialog.toggle()
                    }
                    
                    HStack {
                        Spacer()
                        
                        // Button to trigger sign-up
                        Button("Sign up") {
                            // Trigger the sign-up action in the ViewModel
                            viewModel.signUpButtonTapped()
                        }
                        .buttonStyle(ActionButtonStyle(.large))
                        .padding(.bottom, 32)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                
                // Confirmation dialog for photo upload
                .confirmationDialog("Chose how you want to add a photo", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Camera") {
                        // Camera type
                        pickerSourceType = .camera
                        
                        // Delay showing the picker to avoid UI lag
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showPicker = true
                        }
                    }
                    
                    Button("Gallery") {
                        // Gallery type
                        pickerSourceType = .photoLibrary
                        
                        // Delay showing the picker to avoid UI lag
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showPicker = true
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                
                // Image picker sheet to choose an image from camera or gallery
                .sheet(isPresented: $showPicker) {
                    if let pickerSourceType {
                        PhotoPicker(selectedImage: $selectedImage, sourceType: pickerSourceType)
                    }
                }
                
                // Handles image selection and update the photoData in the ViewModel
                .onChange(of: selectedImage) { _, newValue in
                    guard let newValue else { return }
                    
                    // Convert to jpeg
                    guard let imageData = newValue.jpegData(compressionQuality: 0.8) else { return }
                    
                    viewModel.photoData = imageData
                }
                
                // Fullscreen feedback view (success or failure) after form submission
                .fullScreenCover(isPresented: $viewModel.showFeedbackView, onDismiss: {
                    // After dismissing, clear fields
                    viewModel.clearFields()
                }, content: {
                    // Display feedback based on the status (success or failure)
                    FeedbackView(status: viewModel.feedbackStatus)
                })
            }
        }
    }
}

#Preview {
    SignUpView()
}
