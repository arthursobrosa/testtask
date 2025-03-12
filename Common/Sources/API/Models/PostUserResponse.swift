import Foundation

// PostUserResponse represents the response received when posting a user
public struct PostUserResponse: Decodable {
    public var message: String     // Message returned by the server
    public var fails: FailModel?   // Optional 'fails' property that contains validation errors, if any.
}

// FailModel represents validation errors for different fields in the user registration process
public struct FailModel: Decodable {
    // Arrays of error messages related to specific fields (name, email, phone, photo)
    public var name: [String]?
    public var email: [String]?
    public var phone: [String]?
    public var photo: [String]?
    
    // Textual representation of FailModel
    public var description: String {
        return "Validation Errors: Name: \(name ?? []), Email: \(email ?? []), Phone: \(phone ?? []), Photo: \(photo ?? [])"
    }
}
