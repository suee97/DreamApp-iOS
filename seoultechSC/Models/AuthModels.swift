import Foundation

struct AuthApiResult: Codable {
    let status: Int
    let message: String
    let data: [String]?
    let errorCode: String?
}

struct LoginApiResult: Codable {
    let status: Int
    let message: String
    let data: [[String : String]]?
    let errorCode: String?
}
