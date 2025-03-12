import SwiftUI

// The UserModel represents a user in the system, with properties for user details
public struct UserModel: Decodable, CustomStringConvertible {
    // Properties from JSON
    var id: Int
    public var name: String
    public var email: String
    var phone: String
    public var position: String
    var positionID: Int
    var photoPath: String
    
    // Custom properties
    var photoData: Data?
    
    // Coding keys to map JSON keys to the struct's properties
    private enum CodingKeys: String, CodingKey {
        case positionID = "position_id"
        case photoPath = "photo"
        case id, name, email, phone, position
    }
    
    // Textual representation of UserModel
    public var description: String {
        "\(id)-\(name)"
    }
    
    // Returns an Image gotten from photo data
    public func image() -> Image {
        let defaultImage = Image(systemName: "person.fill")
        
        if let photoData, let uiImage = UIImage(data: photoData) {
            // Returns image from photoData (if it exists)
            return Image(uiImage: uiImage)
        }
        
        // Returns default image in case photoData doesn't exist
        return defaultImage
    }

    // Formats the phone number to the correct format.
    public func formattedPhone() -> String {
        // Removes + sign (if there is any)
        let cleanPhone = phone.replacingOccurrences(of: "+", with: "")
        
        // Pattern for formatting
        let pattern = "+## (###) ### ## ##"
        
        // Determines the character to replaced in the pattern
        let replacementCharacter: Character = "#"
        
        // Storest formatted number
        var formattedNumber = ""
        
        // First index from phone number
        var numberIndex = cleanPhone.startIndex

        // Iterates through to the pattern to create the new number
        for patternChar in pattern {
            // Breaks when the end of phone number is reached
            if numberIndex == cleanPhone.endIndex {
                break
            }

            // Replaces # with the number at the same position
            if patternChar == replacementCharacter {
                formattedNumber.append(cleanPhone[numberIndex])
                numberIndex = cleanPhone.index(after: numberIndex)
            } else {
                // Appends character when it's not #
                formattedNumber.append(patternChar)
            }
        }

        // Returns formatted phone number
        return formattedNumber
    }
    
    public init(
        id: Int = 0,
        name: String = String(),
        email: String = String(),
        phone: String = String(),
        position: String = String(),
        positionID: Int = 0,
        photoPath: String = String(),
        photoData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.position = position
        self.positionID = positionID
        self.photoPath = photoPath
        self.photoData = photoData
    }
}

// Conformance to Equatable, to compare UserModel instances
extension UserModel: Equatable {
    public static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.description == rhs.description
    }
}

// A wrapper to hold a response that contains an array of users
struct UserResponse: Decodable {
    var users: [UserModel]
}
