import Foundation

struct RentApiResult: Codable {
    let status: Int
    let message: String?
    let data: [RentDataModel]?
}

struct RentDataModel: Codable {
    let rentId: Int
    let account: Int
    let purpose: String
    let rentStatus: String
    let itemCategory: String
    let startTime: String
    let endTime: String
    let createdAt: String
    let updatedAt: String
}

struct MyRentDataApiResult: Codable {
    let status: Int
    let message: String?
    let data: [MyRentDataModel]?
}

struct MyRentDataModel: Codable {
    let rentId: Int
    let account: Int
    let purpose: String
    let rentStatus: String
    let itemCategory: String
    let startTime: String
    let endTime: String
    let createdAt: String
    let updatedAt: String
}

struct RentAvailableApiResult: Codable {
    let status: Int
    let message: String?
    let data: [RentItemCountModel]?
}

struct RentItemCountModel: Codable {
    let count: Int
}
