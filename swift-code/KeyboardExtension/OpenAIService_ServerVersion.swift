import Foundation

class OpenAIService {
    private let serverURL: String

    // 改成你公司服务器的地址
    init(serverURL: String = "http://your-company-server.com:8000") {
        self.serverURL = serverURL
    }

    func generateSuggestions(context: String, style: String = "幽默风趣") async throws -> [String] {
        // 调用后端 API
        let url = URL(string: "\(serverURL)/api/generate")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "context": context,
            "style": style
        ]

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
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
    case serverError
    case emptyResponse

    var localizedDescription: String {
        switch self {
        case .serverError:
            return "服务器错误"
        case .emptyResponse:
            return "返回为空"
        }
    }
}
