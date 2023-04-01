import Foundation

struct EventsApiResult: Codable {
    let status: Int
    let message: String?
    let data: [Event]?
}

struct Event: Codable {
    let eventId: Int
    let title: String
    let formLink: String
    let imageUrl: String
    let startTime: String
    let endTime: String
    let eventStatus: String
}

enum EventStatus {
    case BEFORE
    case PROCEEDING
    case END
}
