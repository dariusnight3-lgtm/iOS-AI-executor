import Foundation

class LLMService {
    private let apiKey: String
    private let model: String = "claude-3-5-sonnet-20241022"
    private let baseURL = "https://api.anthropic.com/v1"
    
    init() {
        self.apiKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"] ?? ""
    }
    
    func streamChat(_ message: String) async -> String? {
        let messages = [
            [
                "role": "user",
                "content": message
            ]
        ]
        
        let payload: [String: Any] = [
            "model": model,
            "max_tokens": 1024,
            "messages": messages,
            "stream": false
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            return nil
        }
        
        var request = URLRequest(url: URL(string: "\(baseURL)/messages")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = jsonData
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let content = json["content"] as? [[String: Any]],
               let textContent = content.first?["text"] as? String {
                return textContent
            }
        } catch {
            print("LLM Service error: \(error.localizedDescription)")
        }
        
        return nil
    }
}
