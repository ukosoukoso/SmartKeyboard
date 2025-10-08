import Foundation

// 配置模式
enum APIMode: String, Codable {
    case userKey = "user_key"           // 用户自己的 OpenAI Key
    case companyServer = "company_server"  // 公司服务器
}

class AppSettings {
    static let shared = AppSettings()

    private let defaults = UserDefaults(suiteName: "group.com.smartkeyboard.shared")

    // 当前使用的模式
    var apiMode: APIMode {
        get {
            guard let modeString = defaults?.string(forKey: "api_mode"),
                  let mode = APIMode(rawValue: modeString) else {
                return .companyServer  // 默认用公司服务器（免费）
            }
            return mode
        }
        set {
            defaults?.set(newValue.rawValue, forKey: "api_mode")
        }
    }

    // 公司服务器地址
    var serverURL: String {
        get {
            return defaults?.string(forKey: "server_url") ?? "http://localhost:8000"
        }
        set {
            defaults?.set(newValue, forKey: "server_url")
        }
    }

    // 用户的 OpenAI Key
    var userAPIKey: String? {
        get {
            return KeychainHelper.load(key: "openai_api_key")
        }
        set {
            if let value = newValue {
                KeychainHelper.save(key: "openai_api_key", value: value)
            } else {
                KeychainHelper.delete(key: "openai_api_key")
            }
        }
    }
}
