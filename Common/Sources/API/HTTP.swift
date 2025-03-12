import Foundation

// The HTTP enum holds HTTP-related constants
enum HTTP {
    // Enum to define HTTP methods (GET, POST, etc.)
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    // Enum for HTTP headers, grouping keys and values
    enum Headers {
        
        // Enum to define header keys
        enum Key: String {
            case contentType = "Content-Type"
            case token = "Token" // Used for authentication
        }
        
        // Enum to define possible header values
        enum Value: String {
            case applicationJson = "application/json"    // Header value for JSON content type
            case multipartFormData = "multipart/form-data" // Header value for multipart/form-data content type (used for file uploads)
        }
    }
}

