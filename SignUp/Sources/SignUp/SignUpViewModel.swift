import API
import Combine
import Foundation

class SignUpViewModel: ObservableObject {
    // Service to handle API requests
    private let networkService: APIService = APIService()
    
    // Tracks if data is being loaded
    @Published var isLoading: Bool = true
    
    // Fields for user input
    @Published var nameInput: String = String()
    @Published var nameErrorText: String = String()
    @Published var isNameValid: Bool = true
    
    @Published var emailInput: String = String()
    @Published var emailErrorText: String = String()
    @Published var isEmailValid: Bool = true
    
    @Published var phoneInput: String = String()
    @Published var phoneErrorText: String = String()
    @Published var isPhoneValid: Bool = true
    
    // List of available positions and selected position
    @Published var positions: [PositionModel] = []
    @Published var selectedPositionIndex: Int = 0
    
    // Fields for user photo
    @Published var photoData: Data? {
        didSet {
            isPhotoValid = true
            photoErrorText = String()
        }
    }
    @Published var photoErrorText: String = String()
    @Published var isPhotoValid: Bool = true
    
    // Determines if user should be created
    private var shouldCreateUser: Bool = false {
        willSet {
            if newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    // Triggers user creation when fields are validated
                    createUser()
                }
            }
        }
    }
    
    // Controls visibility and status of "Feedback" screen
    @Published var showFeedbackView: Bool = false
    @Published var feedbackStatus: FeedbackView.Status = .failure
    
    init() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            // Fetch positions when the view model is initialized
            fetchPositions()
        }
    }
    
    // Asynchronous function to fetch available positions from the network
    @MainActor
    private func fetchPositions() {
        Task {
            do {
                // Fetch positions
                positions = try await networkService.fetchPositions()
                
                // Data loaded, hide loading
                isLoading = false
            } catch let error {
                // Print general error message
                print("error fetching positions: \(error.localizedDescription)")
            }
        }
    }
    
    // Formats the phone input to match the specific phone format
    func formatPhoneInput() {
        // Keeps only digits
        let digits = phoneInput.filter { $0.isNumber }
        
        // Handles initial country code
        guard digits.count > 2 else {
            phoneInput = "+" + digits
            return
        }
        
        // Extracts country code
        let countryCode = "+\(digits.prefix(2))"
        
        // Removes country code
        let remainingDigits = digits.dropFirst(2)
        
        // Stores formatted digits
        let formattedRemainingDigits: String
        
        // Formats the remaining digits based on the length of the current phone input
        switch remainingDigits.count {
        case 0..<3:
            formattedRemainingDigits = "\(remainingDigits)"
        case 3..<6:
            formattedRemainingDigits = "(\(remainingDigits.prefix(3))) \(remainingDigits.dropFirst(3))"
        case 6..<8:
            formattedRemainingDigits = "(\(remainingDigits.prefix(3))) \(remainingDigits.dropFirst(3).prefix(3)) \(remainingDigits.dropFirst(6))"
        default:
            formattedRemainingDigits = "(\(remainingDigits.prefix(3))) \(remainingDigits.dropFirst(3).prefix(3)) \(remainingDigits.dropFirst(6).prefix(2)) \(remainingDigits.dropFirst(8).prefix(2))"
        }
        
        // Set phone input as being the sum of the country code and the new remaining digits
        phoneInput = "\(countryCode) \(formattedRemainingDigits)"
    }
    
    // Triggered when the sign-up button is tapped
    func signUpButtonTapped() {
        // Validates the fields before submitting
        validateFields()
    }
    
    // Validates all fields for correctness
    private func validateFields() {
        // Check if all fields are valid and set error messages
        isNameValid = !nameInput.isEmpty
        nameErrorText = nameInput.isEmpty ? "Required field" : String()
        
        isEmailValid = !emailInput.isEmpty
        emailErrorText = emailInput.isEmpty ? "Required field" : String()
        
        isPhoneValid = !phoneInput.isEmpty
        phoneErrorText = phoneInput.isEmpty ? "Required field" : String()
        
        isPhotoValid = photoData != nil
        photoErrorText = photoData == nil ? "Photo required" : String()
        
        // If all fields are valid, prepares to create user
        shouldCreateUser = isNameValid && isEmailValid && isPhoneValid && isPhotoValid
    }
    
    // Asynchronous function to create a user
    @MainActor
    private func createUser() {
        // Shows loading indicator
        isLoading = true
        
        Task {
            do {
                // Create new user model
                let userModel = UserModel(
                    name: nameInput,
                    email: emailInput,
                    phone: phoneInput.filter({ $0.isNumber }), // Sends only numeric phone digits
                    positionID: positions[selectedPositionIndex].id, // Selected position ID
                    photoData: photoData
                )
                
                // Try posting the new user
                try await networkService.createUser(userModel)
                
                // Hides loading indicator
                isLoading = false
                
                // Sets success feedback
                feedbackStatus = .success
                
                // Shows feedback view
                showFeedbackView.toggle()
                
            } catch let APIServiceError.invalidUser(response) {
                // Handles invalid user errors
                updateFields(using: response)
                isLoading = false
            }
        }
    }
    
    // Updates fields based on the response from the network request
    private func updateFields(using response: PostUserResponse) {
        // Unwraps fails list from response
        guard let fails = response.fails else {
            // When there are no fails from response, that means all the inputs are correct,
            // but the email or the phone already exist
            feedbackStatus = .failure
            showFeedbackView = true
            return
        }
        
        // Create specific error lists based on the 'fails' property from response
        let nameErrors: [String] = fails.name ?? []
        let emailErrors: [String] = fails.email ?? []
        let phoneErrors: [String] = fails.phone ?? []
        let photoErrors: [String] = fails.photo ?? []
        
        // Change fields validation and error messages based on the created error lists
        isNameValid = nameErrors.isEmpty
        nameErrorText = nameErrors.first ?? nameErrorText
        
        isEmailValid = emailErrors.isEmpty
        emailErrorText = emailErrors.first ?? emailErrorText
        
        isPhoneValid = phoneErrors.isEmpty
        phoneErrorText = phoneErrors.first ?? phoneErrorText
        
        isPhotoValid = photoErrors.isEmpty
        photoErrorText = photoErrors.first ?? photoErrorText
    }
    
    // Clear all fields
    func clearFields() {
        // Ensures the user successfully created a user
        guard case .success = feedbackStatus else { return }
        
        // Clear necessary properties
        nameInput = String()
        emailInput = String()
        phoneInput = String()
        selectedPositionIndex = 0
        photoData = nil
    }
}
