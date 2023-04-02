import Foundation
import SwiftKeychainWrapper

class KeychainHelper {
    static let sharedKeychain = KeychainHelper()
    
    private init(){}
    
    func saveAccessToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: "ACCESS_TOKEN")
        print("access token saved : \(token)")
    }
    
    func saveRefreshToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: "REFRESH_TOKEN")
        print("refresh token saved : \(token)")
    }
    
    func getAccessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "ACCESS_TOKEN")
    }
    
    func getRefreshToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "REFRESH_TOKEN")
    }
    
    func resetAccessRefreshToken() {
        self.saveAccessToken("")
        self.saveRefreshToken("")
    }
}
