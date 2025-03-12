import Foundation

// The PositionModel represents a position in the system, with properties for position details.
public struct PositionModel: Decodable, Hashable {
    public var id: Int
    public var name: String
}

// A wrapper to hold a response that contains an array of positions
struct PositionResponse: Decodable {
    var positions: [PositionModel]
}
