import Foundation

// Enum representing different API endpoints and the associated parameters for each endpoint
enum Endpoint {
    // Endpoint for fetching users with optional pagination
    case fetchUsers(page: Int? = nil, count: Int? = nil)
    
    // Endpoint for fetching a token
    case fetchToken
    
    // Endpoint for fetching positions
    case fetchPositions
    
    // Endpoint for posting a user
    case createUser(
        boundary: String = "Boundary-\(UUID().uuidString)", // Boundary string for multipart form data
        token: String,                                      // Authentication token
        userModel: UserModel                                // A user model containing details to create a user
    )
    
    // Computed property that returns a URLRequest for the endpoint
    var request: Result<URLRequest, APIServiceError> {
        guard let url else {
            return .failure(.invalidURL)
        }
        
        // Create URLRequest from URL
        var request = URLRequest(url: url)
        
        // Set the HTTP method (GET/POST)
        request.httpMethod = httpMethod
        
        // Set the HTTP body for POST requests
        request.httpBody = httpBody
        
        // Add necessary headers based on the endpoint
        request.addValues(for: self)
        
        // Return the constructed URLRequest
        return .success(request)
    }
    
    // Computed property that constructs the URL for the endpoint
    private var url: URL? {
        // Create URLComponents
        var components = URLComponents()
        
        // URL scheme (http/https)
        components.scheme = Constants.scheme
        
        // Base URL of the API
        components.host = Constants.baseURL
        
        // Port for the API
        components.port = Constants.port
        
        // Path for the specific endpoint
        components.path = path
        
        // Optional query parameters
        components.queryItems = queryItems
        
        // Constructed URL
        return components.url
    }
    
    // Computed property to determine the API path based on the endpoint
    private var path: String {
        switch self {
        case .fetchUsers:
            return "/api/v1/users"
        case .fetchToken:
            return "/api/v1/token"
        case .fetchPositions:
            return "/api/v1/positions"
        case .createUser:
            return "/api/v1/users"
        }
    }
    
    // Computed property to handle query parameters (used in GET requests)
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchUsers(let page, let count):
            // Set pagination when fetching users
            var items: [URLQueryItem] = []
            
            if let page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
            }
            
            if let count {
                items.append(URLQueryItem(name: "count", value: "\(count)"))
            }
            
            return items
        case .fetchToken, .fetchPositions, .createUser:
            return nil
        }
    }
    
    // Computed property to return the HTTP method based on the endpoint (GET or POST)
    private var httpMethod: String {
        switch self {
        case .fetchUsers, .fetchToken, .fetchPositions:
            return HTTP.Method.get.rawValue
        case .createUser:
            return HTTP.Method.post.rawValue
        }
    }
    
    // Computed property to return the HTTP body for POST requests
    var httpBody: Data? {
        switch self {
        case .fetchUsers, .fetchToken, .fetchPositions:
            return nil // No body for GET requests
        case .createUser(let boundary, _, let userModel):
            // Create multipart form data based on passed boundary
            var formData = MultipartFormData(boundary: boundary)
            
            // Add user data fields to the multipart form data
            formData.addField(name: "name", value: userModel.name)
            formData.addField(name: "email", value: userModel.email)
            formData.addField(name: "phone", value: userModel.phone)
            formData.addField(name: "position_id", value: "\(userModel.positionID)")
            formData.addFile(name: "photo", filename: "photo.jpg", mimeType: "image/jpeg", fileData: userModel.photoData)
            
            // Return the finalized multipart form data
            return formData.finalize()
        }
    }
}

// Extension for URLRequest to add the necessary headers based on the endpoint
extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .fetchUsers, .fetchToken, .fetchPositions:
            // Set Content-Type header for GET requests to application/json
            setValue(HTTP.Headers.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
        case .createUser(let boundary, let token, _):
            // Set Content-Type header for POST requests with multipart form data
            let contentTypeValue = HTTP.Headers.Value.multipartFormData.rawValue + "; boundary=\(boundary)"
            setValue(contentTypeValue, forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            
            // Set Authorization token in the request header
            setValue(token, forHTTPHeaderField: HTTP.Headers.Key.token.rawValue)
        }
    }
}
