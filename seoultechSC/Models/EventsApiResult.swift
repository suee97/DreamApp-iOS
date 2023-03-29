import Foundation

struct EventsApiResult {
    let status: Int
    let message: String?
    let data: [Event]?
}

struct Event {
    let eventId: Int
    let title: String
    let formLink: String
    let imageUrl: String
    let startTime: String
    let endTime: String
    let eventStatus: String
}
