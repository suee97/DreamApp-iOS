import Foundation

struct RoomEscapeApiResult: Codable {
    let status: Int
    let message: String?
    let data: [RoomEscapeInfo]?
    let errorCode: String?
}

struct RoomEscapeInfo: Codable {
    let roomId: Int
    let imageUrl: String
}

struct RoomEscapeAnswerApiResult: Codable {
    let status: Int
    let message: String?
    let data: [RoomEscapeAnswer]?
    let errorCode: String?
}

struct RoomEscapeAnswer: Codable {
    let answer: Bool?
}

struct RoomEscapeHistoryApiResult: Codable {
    let status: Int
    let message: String?
    let data: [RoomEscapeHistory]?
    let errorCode: String?
}

struct RoomEscapeHistory: Codable {
    let roomId: Int
}
