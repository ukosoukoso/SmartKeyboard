import Foundation
import OpenAI

class OpenAIService {
    private let client: OpenAI

    init(apiKey: String) {
        self.client = OpenAI(apiToken: apiKey)
    }

    func generateSuggestions(context: String, style: String = "幽默风趣") async throws -> [String] {
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
            temperature: 0.8,
            maxTokens: 200
        )

        let result = try await client.chats(query: query)

        guard let content = result.choices.first?.message.content?.string else {
            throw OpenAIError.emptyResponse
        }

        // 解析返回的建议
        let suggestions = content
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { suggestion in
                // 移除可能的编号（1. 2. 等）
                suggestion.replacingOccurrences(of: "^\\d+\\.\\s*", with: "", options: .regularExpression)
            }
            .prefix(3)

        return Array(suggestions)
    }
}

enum OpenAIError: Error {
    case emptyResponse

    var localizedDescription: String {
        switch self {
        case .emptyResponse:
            return "OpenAI 返回为空"
        }
    }
}
