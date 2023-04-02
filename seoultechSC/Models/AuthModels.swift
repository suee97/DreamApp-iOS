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

struct JWTApiResult: Codable {
    let status: Int
    let message: String
    let data: [JWTMember]?
    let errorCode: String?
}

struct JWTMember: Codable {
    let memberId: Int
    let role: String
}

struct RefreshResult: Codable {
    let status: Int
    let message: String
    let data: [[String: String]]?
    let errorCode: String?
}
