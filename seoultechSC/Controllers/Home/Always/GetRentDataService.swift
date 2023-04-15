//import Foundation
//import Alamofire
//
//struct GetRentDataService {
//    
//    static let shared = GetRentDataService()
//    
//    func loadAvailableItemCount(completion : @escaping (NetworkResult<Any>) -> Void) {
//        
//        let url = "\(api_url)/rent/calendar?category=TABLE"
//        
////        let url = "\(api_url)/rent/item/calendar?category=CANOPY"
//        let header : HTTPHeaders = ["Content-Type": "application/json"]
//        
//        let dataRequest = AF.request(url,
//                                     method: .get,
//                                     encoding: JSONEncoding.default,
//                                     headers: header)
//        
//        dataRequest.responseData { dataResponse in
//            
//            switch dataResponse.result {
//            case .success:
//                guard let statusCode = dataResponse.response?.statusCode else { return }
//                
//                guard let value = dataResponse.value else { return }
//                
//                let networkResult = judgeStatus(by: statusCode, value)
//                completion(networkResult)
//                
//            case .failure: completion(.pathErr)
//            }
//            
//        }
//        
//    }
//    
//    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
//        switch statusCode {
//        case 200: return isVaildData(data: data)
//        case 400: return .pathErr
//        case 500: return .serverErr
//        default: return .networkFail
//        }
//    }
//    
//    private func isVaildData(data: Data) -> NetworkResult<Any> {
//        let decoder = JSONDecoder()
//        
//        guard let decodedData = try? decoder.decode(RentDataModel.self, from: data) else { return .pathErr }
//        
//        return .success(decodedData.data)
//    }
//    
//}
