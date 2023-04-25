import Foundation
import GoogleMaps

struct Stamp {
    let name: String
    let location: CLLocationCoordinate2D
}

struct StampStatusResult: Codable {
    let status: Int
    let message: String
    let data: [StampStatus]?
    let errorCode: String?
}

struct StampStatus: Codable {
    let stampId: Int
    let memberId: Int
    let game: Bool
    let yard: Bool
    let stage: Bool
    let bungeobang: Bool
    let photo: Bool
    let isPrized: Bool
}

struct PostStampStatus: Codable {
    let data: [String]?
    let message: String
    let errorCode: String?
    let status: Int
}

struct FoodTruckApiResult: Codable {
    let status: Int
    let message: String
    let data: [TruckList]
}

struct TruckList: Codable {
    let truckList: [FoodTruck]
}

struct FoodTruck: Codable {
    let truckId: Int
    let truckName: String
    let truckDescription: String?
    let truckLocation: String
}

struct Booth: Codable {
    let boothId: Int
    let name: String
    let congestion: Int
}

struct LineUp: Codable {
    let lineUpId: Int
    let lineUpTitle: String
    let lineUpDay: String
    let lineUpTime: String
}

struct BoothData: Codable {
    let boothList: [Booth]
    let lineUpList: [LineUp]
}

struct BoothApiResult: Codable {
    let status: Int
    let message: String
    let data: [BoothData]?
    let errorCode: String?
}

struct Contents {
    let id: Int // 1~9
    let image: UIImage
    let title: String
    var congestion: Int // 1~3
    let time: String // 11:00 ~ 18:00
    let desc: String // 3줄
}

struct PhotoZone: Codable {
    let photoId: Int
    let photoName: String
    let photoDescription: String
    let photoImageUrl: String
}

struct PhotoZoneWithImage {
    let photoId: Int
    let photoName: String
    let photoDescription: String
    let image: UIImage
}

struct PhotoData: Codable {
    let photoList: [PhotoZone]
}

struct PhotoZoneResult: Codable {
    let status: Int
    let message: String?
    let data: [PhotoData]
    let errorCode: String?
}
