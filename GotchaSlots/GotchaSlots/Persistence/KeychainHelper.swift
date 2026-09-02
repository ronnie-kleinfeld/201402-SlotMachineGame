import Foundation
import Security

/// Raw byte-level read/write against the iOS Keychain — the direct analog of AS3's
/// `flash.data.EncryptedLocalStore.getItem/setItem`, which is itself backed by the device
/// Keychain under the hood on iOS. Uses `kSecClassGenericPassword` with the app's bundle
/// identifier as the access group scope (implicit — no explicit access group set, so items are
/// private to this app, matching EncryptedLocalStore's per-app isolation).
enum KeychainHelper {
    static func read(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    /// Upsert: updates the existing item if present, otherwise adds a new one — mirrors
    /// EncryptedLocalStore.setItem's overwrite-in-place semantics.
    static func write(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            let update: [String: Any] = [kSecValueData as String: data]
            SecItemUpdate(query as CFDictionary, update as CFDictionary)
        } else {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }

    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]
        SecItemDelete(query as CFDictionary)
    }
}
