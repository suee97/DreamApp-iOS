import Foundation
import Alamofire

class AuthHelper {
    static let shared = AuthHelper()
    
    private init(){}
    
    func authAccessToken(completion: @escaping (JWTAuthTokenResult) -> Void) {
        let url = "\(api_url)/auth"
        let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]

        let request = AF.request(url,
                                 method: .get,
                                 parameters: nil,
                                 headers: header
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(JWTApiResult.self, from: responseData)
                    if result.status == 200 {
                        completion(.authorized)
                    } else if result.errorCode == "ST011" {
                        completion(.expired)
                    } else {
                        completion(.fail)
                    }
                } catch {
                    completion(.fail)
                }
            case .failure:
                completion(.fail)
            }
        }
    }
    
    func refreshAccessToken(completion: @escaping (RefreshAccessTokenResult) -> Void) {
        let url = "\(api_url)/auth/refresh"
        let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let rToken: String = KeychainHelper.sharedKeychain.getRefreshToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)",
            "refresh" : "Bearer \(rToken)"
        ]

        let request = AF.request(url,
                                 method: .get,
                                 parameters: nil,
                                 headers: header
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(RefreshResult.self, from: responseData)
                    if result.status == 200 {
                        KeychainHelper.sharedKeychain.saveAccessToken(result.data![0]["accessToken"]!)
                        print("AccessToken Refreshed : \(result.data![0]["accessToken"]!)")
                        completion(.refreshed)
                    } else {
                        completion(.fail)
                    }
                } catch {
                    completion(.fail)
                }
            case .failure:
                completion(.fail)
            }
        }
    }
    
    func getUserInfo(completion: @escaping (GetUserInfoResult) -> Void) {
        let url = "\(api_url)/member"
        let aToken: String = KeychainHelper.sharedKeychain.getAccessToken() ?? ""
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(aToken)"
        ]

        let request = AF.request(url,
                                 method: .get,
                                 parameters: nil,
                                 headers: header
        ).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    guard let responseData = response.data else { return }
                    let result = try decoder.decode(UserInfo.self, from: responseData)
                    if result.status == 200 {
                        print("get user info : success")
                        completion(.success)
                        signInUser = result.data![0]
                    } else {
                        completion(.fail)
                    }
                } catch {
                    completion(.fail)
                }
            case .failure:
                completion(.fail)
            }
        }
    }
}

enum JWTAuthTokenResult {
    case authorized
    case expired
    case fail // jwt 값 위조, 변경, 헤더에 토큰 없는 경우 + 그 외 에러
}

enum RefreshAccessTokenResult {
    case refreshed
    case fail
}

enum GetUserInfoResult {
    case success
    case fail
}
