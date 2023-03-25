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
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        switch status {
        case errSecSuccess:
            // Item exists in keychain, update it
            let updateQuery: [String: Any] = [
                kSecValueData as String: data
            ]
            let updateStatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
            guard updateStatus == errSecSuccess else {
                print("Failed to update token in keychain: \(updateStatus)")
                return
            }
            print("Refresh Token updated successfully")
        case errSecItemNotFound:
            // Item doesn't exist in keychain, add it
            let addQuery: [String: Any] = [
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                print("Failed to save token to keychain: \(addStatus)")
                return
            }
            print("Access Token saved successfully: ")
        default:
            print("Error retrieving token from keychain: \(status)")
            return
        }
        
        print("new access token : \(token)")

    }
    
    func saveRefreshToken(_ token: String) {
        let data = token.data(using: .utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "REFRESH_TOKEN",
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        switch status {
        case errSecSuccess:
            // Item exists in keychain, update it
            let updateQuery: [String: Any] = [
                kSecValueData as String: data
            ]
            let updateStatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
            guard updateStatus == errSecSuccess else {
                print("Failed to update token in keychain: \(updateStatus)")
                return
            }
            print("Refresh Token updated successfully: ")
        case errSecItemNotFound:
            // Item doesn't exist in keychain, add it
            let addQuery: [String: Any] = [
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                print("Failed to save token to keychain: \(addStatus)")
                return
            }
            print("Refresh Token saved successfully")
        default:
            print("Error retrieving token from keychain: \(status)")
            return
        }

        print("new refresh token : \(token)")
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
    
    func resetAccessRefreshToken() {
        self.saveAccessToken("")
        self.saveRefreshToken("")
    }
}
