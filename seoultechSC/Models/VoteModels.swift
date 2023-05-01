import Foundation

struct VoteListApiResult: Codable {
    let status: Int
    let message: String?
    let data: [Vote]?
    let errorCode: String?
}

struct Vote: Codable {
    let votingId: Int
    let title: String
    let status: String
    let description: String
    let minSelect: Int
    let maxSelect: Int
    let displayStartDate: String
    let displayEndDate: String
    let voteOptionList: [VoteOption]
    let userSelectedOptionIds: [Int]
}

struct VoteOption: Codable {
    let votingOptionId: Int
    let optionTitle: String
    let status: String
}
