import Foundation

struct AuthApiResult: Codable {
    let status: Int
    let message: String
    let data: [String]?
    let errorCode: String?
}
