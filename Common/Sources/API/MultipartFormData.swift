import Foundation

// Struct that handles creating a multipart/form-data body for HTTP requests
struct MultipartFormData {
    // Boundary used to separate different parts in the form data
    private let boundary: String
    
    // Data object to accumulate the body content
    private var body = Data()
    
    init(boundary: String) {
        self.boundary = boundary
    }
    
    // Adds a text field to the multipart form data
    mutating func addField(name: String, value: String) {
        // Format the field as required by multipart/form-data format
        let field = "--\(boundary)\r\n"
        + "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        + "\(value)\r\n"
        
        // Convert the field to Data and append to the body
        if let fieldData = field.data(using: .utf8) {
            body.append(fieldData)
        } else {
            print("failed to convert field")
        }
    }
    
    // Adds a file field to the multipart form data
    mutating func addFile(name: String, filename: String, mimeType: String, fileData: Data?) {
        // Format the file as required by multipart/form-data format
        let field = "--\(boundary)\r\n"
        + "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
        + "Content-Type: \(mimeType)\r\n\r\n"
        
        // Convert the field and append the file data
        if let fieldData = field.data(using: .utf8),
           let fileData,
           let lineBreakData = "\r\n".data(using: .utf8) {
            
            body.append(fieldData)
            body.append(fileData)
            body.append(lineBreakData)
        } else {
            print("failed to convert field")
        }
    }
    
    // Finalizes the body and appends the closing boundary
    mutating func finalize() -> Data? {
        // Add the final boundary marking the end of the form data
        guard let boundaryData = "--\(boundary)--\r\n".data(using: .utf8) else {
            return nil
        }
        
        // Append the final boundary
        body.append(boundaryData)
        
        return body
    }
}
