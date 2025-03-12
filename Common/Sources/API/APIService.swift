import Foundation

// APIService class handles making network requests and processing the responses
public class APIService {
    public init() {}
    
    // Performs the network request using the URLRequest and returns the data and response
    private func performRequest(_ request: Result<URLRequest, APIServiceError>) async throws -> (Data, HTTPURLResponse) {
        var urlRequest: URLRequest
        
        // Check if the request was successful (Success or Failure case)
        switch request {
        case .success(let request):
            // Use the request if successful
            urlRequest = request
        case .failure(let error):
            // Throw the error if failure
            throw error
        }
        
        // Perform the network request asynchronously using URLSession
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Ensure the response is an HTTPURLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            // Throw if the response is not an HTTP response
            throw APIServiceError.invalidResponse
        }
        
        // Return the data and response
        return (data, httpResponse)
    }
    
    // Decodes the provided data into a Decodable object of type T
    private func decodeData<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            
            // Decode the data to type T
            let decodedObject = try decoder.decode(T.self, from: data)
            
            return decodedObject
        } catch {
            // Throw decoding error if failed
            throw APIServiceError.decodingError
        }
    }
    
    // Fetches a list of users for a specific page
    public func fetchUsers(page: Int) async throws -> [UserModel] {
        // Define the endpoint for fetching users
        let endPoint: Endpoint = .fetchUsers(page: page, count: 6)
        
        // Get the URLRequest for the endpoint
        let request = endPoint.request
        
        // Perform the request and get data and response
        let (data, response) = try await performRequest(request)
        
        // Check if the response status code is 200 (OK)
        guard response.statusCode == 200 else {
            // Throw if status code is not 200
            throw APIServiceError.invalidStatusCode(response.statusCode)
        }
        
        // Decode the response data into a UserResponse object
        let userResponse: UserResponse = try decodeData(data)
        
        // Fetch users with their photos adn return them
        return await fetchUsersWithPhoto(for: userResponse.users)
    }
    
    // Fetches photos for each user asynchronously in parallel
    private func fetchUsersWithPhoto(for users: [UserModel]) async -> [UserModel] {
        var usersWithPhoto = users
        
        // Use a task group to fetch images in parallel
        await withTaskGroup(of: Void.self) { group in
            for (index, user) in users.enumerated() {
                group.addTask { [weak self] in
                    guard let self else { return }
                    
                    // Fetch the photo data for each user
                    do {
                        usersWithPhoto[index].photoData = try await fetchUserImageData(from: user.photoPath)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        // Return users with their photos
        return usersWithPhoto
    }
    
    // Fetches user image data from a provided URL
    private func fetchUserImageData(from urlString: String) async throws -> Data? {
        // Convert string to URL
        let url = URL(string: urlString)
        
        guard let url else {
            // Throw if the URL is invalid
            throw APIServiceError.invalidImage(urlString: urlString)
        }
        
        // Perform the image fetch request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check if the response is a HTTPURLResponse
        // and if status code is 200 (OK)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            // Throw error in case of failure
            throw APIServiceError.invalidImage(urlString: urlString)
        }
        
        // Return image data
        return data
    }
    
    // Fetches a token to authenticate further requests
    private func fetchToken() async throws -> String {
        // Define the endpoint for fetching the token
        let endPoint: Endpoint = .fetchToken
        
        // Get the URLRequest for the endpoint
        let request = endPoint.request
        
        // Perform the request and get data and response
        let (data, response) = try await performRequest(request)
        
        // Check if the response status code is 200 (OK)
        guard response.statusCode == 200 else {
            // Throw if status code is not 200
            throw APIServiceError.invalidStatusCode(response.statusCode)
        }
        
        // Decode the response data into a TokenModel object
        let tokenModel: TokenModel = try decodeData(data)
        
        // Return token string from token model
        return tokenModel.token
    }
    
    // Fetches a list of positions
    public func fetchPositions() async throws -> [PositionModel] {
        // Define the endpoint for fetching positions
        let endPoint: Endpoint = .fetchPositions
        
        // Get the URLRequest for the endpoint
        let request = endPoint.request
        
        // Perform the request and get data and response
        let (data, response) = try await performRequest(request)
        
        // Check if the response status code is 200 (OK)
        guard response.statusCode == 200 else {
            // Throw if status code is not 200
            throw APIServiceError.invalidStatusCode(response.statusCode)
        }
        
        // Decode the response data into a PositionResponse object
        let positionResponse: PositionResponse = try decodeData(data)
        
        // Return array of positions from positions response
        return positionResponse.positions
    }
    
    // Creates a new user by sending the user data along with an authentication token
    public func createUser(_ userModel: UserModel) async throws {
        // Fetch a new token to authenticate the request
        let newToken = try await fetchToken()
        
        // Define the endpoint to create a user
        let endPoint: Endpoint = .createUser(token: newToken, userModel: userModel)
        
        // Get the URLRequest for the endpoint
        let request = endPoint.request
        
        // Perform the request and get data and response
        let (data, response) = try await performRequest(request)
        
        // Check if the response status code is 201 (Created)
        guard response.statusCode == 201 else {
            // Decode the error response into PostUserResponse if user creation fails
            let postUserResponse: PostUserResponse = try decodeData(data)
            
            // Throw error with the response details
            throw APIServiceError.invalidUser(response: postUserResponse)
        }
    }
}
