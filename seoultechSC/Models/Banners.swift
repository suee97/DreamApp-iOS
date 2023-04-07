import Foundation

struct Banners: Codable {
    let status: Int
    let message: String
    let data: [Banner]
}

struct Banner: Codable {
    let bannerId: Int
    let title: String
    let imageUrl: String
    let priority: Int
    let isDeleted: Bool
    let createdAt: String
    let updatedAt: String
}
