import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    // 保存到 Keychain
    static func save(key: String, value: String) {
        let data = value.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessGroup as String: "group.com.smartkeyboard.shared" // App Group
        ]

        // 删除旧的
        SecItemDelete(query as CFDictionary)

        // 添加新的
        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("❌ Keychain save failed: \(status)")
        } else {
            print("✅ Keychain save success")
        }
    }

    // 从 Keychain 读取
    static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecAttrAccessGroup as String: "group.com.smartkeyboard.shared"
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }

        print("⚠️ Keychain load failed: \(status)")
        return nil
    }

    // 删除
    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessGroup as String: "group.com.smartkeyboard.shared"
        ]

        SecItemDelete(query as CFDictionary)
    }
}
