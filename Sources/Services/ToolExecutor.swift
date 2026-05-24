import Foundation

class ToolExecutor {
    private var tools: [String: (Any) -> String] = [:]
    
    func registerTool(name: String, description: String, handler: @escaping (Any) -> String) {
        tools[name] = handler
    }
    
    func execute(_ taskDescription: String) async -> String {
        let components = taskDescription.trimmingCharacters(in: .whitespaces).split(separator: ":", maxSplits: 1)
        
        guard components.count >= 1 else {
            return "Invalid task format"
        }
        
        let toolName = String(components[0]).trimmingCharacters(in: .whitespaces)
        let args = components.count > 1 ? String(components[1]) : ""
        
        if let handler = tools[toolName] {
            return handler(args)
        }
        
        return "Tool not found: \(toolName)"
    }
}
