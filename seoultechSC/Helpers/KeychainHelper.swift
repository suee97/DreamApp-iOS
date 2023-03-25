import Foundation
import Security

class KeychainHelper {
    static let sharedKeychain = KeychainHelper()
    
    private init(){}
    
    func saveAccessToken(_ token: String) {
        let data = token.data(using: .utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ACCESS_TOKEN",
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save token to keychain: \(status)")
            return
        }
    }
    
    func saveRefreshToken(_ token: String) {
        let data = token.data(using: .utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "REFRESH_TOKEN",
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save token to keychain: \(status)")
            return
        }
    }
    
    func getAccessToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ACCESS_TOKEN",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess else {
            print("Failed to retrieve token from keychain: \(status)")
            return nil
        }
        
        guard let data = dataTypeRef as? Data else {
            print("Unexpected data type")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func getRefreshToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "REFRESH_TOKEN",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        guard status == errSecSuccess else {
            print("Failed to retrieve token from keychain: \(status)")
            return nil
        }
        
        guard let data = dataTypeRef as? Data else {
            print("Unexpected data type")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func resetAccessToken() {
        let token: String = ""
        let data = token.data(using: .utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ACCESS_TOKEN",
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save token to keychain: \(status)")
            return
        }
    }
    
    func resetRefreshToken() {
        let token: String = ""
        let data = token.data(using: .utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "REFRESH_TOKEN",
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save token to keychain: \(status)")
            return
        }
    }
    
    func resetAccessRefreshToken() {
        self.resetAccessToken()
        self.resetRefreshToken()
    }
}
