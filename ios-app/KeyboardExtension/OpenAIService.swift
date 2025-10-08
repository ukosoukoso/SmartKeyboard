import Foundation
import OpenAI

class OpenAIService {
    private let settings = AppSettings.shared
    private var openAIClient: OpenAI?

    init() {
        // 根据模式初始化
        if settings.apiMode == .userKey, let apiKey = settings.userAPIKey {
            openAIClient = OpenAI(apiToken: apiKey)
        }
    }

    func generateSuggestions(context: String, style: String = "幽默风趣") async throws -> [String] {
        switch settings.apiMode {
        case .userKey:
            return try await generateWithUserKey(context: context, style: style)
        case .companyServer:
            return try await generateWithServer(context: context, style: style)
        }
    }

    // 方式 A: 用户自己的 OpenAI Key
    private func generateWithUserKey(context: String, style: String) async throws -> [String] {
        guard let client = openAIClient else {
            throw OpenAIError.noAPIKey
        }

        let systemPrompt = """
        你是一个专业的聊天助手，帮助用户生成\(style)的聊天回复。

        规则：
        1. 生成3个不同的回复建议
        2. 风格要\(style)
        3. 适合追女生的场景
        4. 每个建议控制在30字以内
        5. 直接返回建议，不要编号，用换行符分隔
        6. 要自然、不做作、有趣
        """

        let userPrompt = "我想回复：\(context)\n\n请生成3个\(style)的回复建议。"

        let query = ChatQuery(
            messages: [
                .init(role: .system, content: systemPrompt)!,
                .init(role: .user, content: userPrompt)!
            ],
            model: .gpt3_5Turbo,
            temperature: 0.8
        )

        let result = try await client.chats(query: query)

        guard let content = result.choices.first?.message.content else {
            throw OpenAIError.emptyResponse
        }

        // 解析返回的建议
        let suggestions = content
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { suggestion in
                suggestion.replacingOccurrences(of: "^\\d+\\.\\s*", with: "", options: String.CompareOptions.regularExpression)
            }
            .prefix(3)

        return Array(suggestions)
    }

    // 方式 B: 公司服务器
    private func generateWithServer(context: String, style: String) async throws -> [String] {
        let serverURL = settings.serverURL
        guard let url = URL(string: "\(serverURL)/api/generate") else {
            throw OpenAIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        let body: [String: String] = [
            "context": context,
            "style": style
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.serverError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw OpenAIError.serverError
        }

        let result = try JSONDecoder().decode(GenerateResponse.self, from: data)
        return result.suggestions
    }
}

struct GenerateResponse: Codable {
    let suggestions: [String]
}

enum OpenAIError: Error {
    case noAPIKey
    case invalidURL
    case serverError
    case emptyResponse

    var localizedDescription: String {
        switch self {
        case .noAPIKey:
            return "请先设置 OpenAI API Key"
        case .invalidURL:
            return "服务器地址无效"
        case .serverError:
            return "服务器错误"
        case .emptyResponse:
            return "返回为空"
        }
    }
}
