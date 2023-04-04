import Foundation

struct UserInfo: Decodable {
    let status: Int
    let message: String?
    let data: [User]?
}

struct User: Decodable{
    var memberId: Int
    var studentNo: String
    var name: String
    var department: String
    var phoneNo: String
    var memberShip: Bool
    var createdAt: String
    var updatedAt: String
    var memberStatus: String
}
