import Foundation
import Combine
import AVFoundation
import Speech

@Observable
class RonixExecutor: NSObject, ObservableObject {
    static let shared = RonixExecutor()
    
    var chatHistory: [ChatMessage] = []
    var isProcessing: Bool = false
    var currentTask: String = ""
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var llmService: LLMService?
    private var toolExecutor: ToolExecutor?
    
    override init() {
        super.init()
        setupSpeech()
    }
    
    func initialize() {
        llmService = LLMService()
        toolExecutor = ToolExecutor()
        
        toolExecutor?.registerTool(
            name: "search",
            description: "Search for information",
            handler: { args in
                let query = args as? String ?? ""
                return "Search results for: \(query)"
            }
        )
        
        toolExecutor?.registerTool(
            name: "calculate",
            description: "Perform mathematical calculations",
            handler: { args in
                let expression = args as? String ?? ""
                return "Calculation: \(expression) = result"
            }
        )
        
        chatHistory.append(
            ChatMessage(
                role: "assistant",
                content: "🚀 RONIX AI EXECUTOR ONLINE. Anti-gravity LLM ready. Command input awaiting...",
                timestamp: ISO8601DateFormatter().string(from: Date())
            )
        )
    }
    
    func chat(_ message: String) async {
        chatHistory.append(
            ChatMessage(
                role: "user",
                content: message,
                timestamp: ISO8601DateFormatter().string(from: Date())
            )
        )
        
        isProcessing = true
        
        if let response = await llmService?.streamChat(message) {
            chatHistory.append(
                ChatMessage(
                    role: "assistant",
                    content: response,
                    timestamp: ISO8601DateFormatter().string(from: Date())
                )
            )
        }
        
        isProcessing = false
    }
    
    func voiceInput() async -> String? {
        return await withCheckedContinuation { continuation in
            requestMicrophoneAccess { granted in
                if granted {
                    self.startListening { result in
                        continuation.resume(returning: result)
                    }
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func executeTask(_ taskDescription: String) async {
        currentTask = taskDescription
        isProcessing = true
        
        let steps = taskDescription.split(separator: ",").map(String.init)
        
        for step in steps {
            let result = await toolExecutor?.execute(step) ?? "Task step completed"
            chatHistory.append(
                ChatMessage(
                    role: "assistant",
                    content: "✓ \(result)",
                    timestamp: ISO8601DateFormatter().string(from: Date())
                )
            )
        }
        
        isProcessing = false
    }
    
    private func setupSpeech() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        requestSpeechAuthorization()
    }
    
    private func requestSpeechAuthorization(_ completion: @escaping (Bool) -> Void = { _ in }) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus == .authorized)
            }
        }
    }
    
    private func requestMicrophoneAccess(_ completion: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    private func startListening(_ completion: @escaping (String?) -> Void) {
        guard let recognizer = speechRecognizer else {
            completion(nil)
            return
        }
        
        do {
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let recognitionRequest = recognitionRequest else {
                completion(nil)
                return
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result, result.isFinal {
                    completion(result.bestTranscription.formattedString)
                } else if let error = error {
                    print("Speech recognition error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        } catch {
            completion(nil)
        }
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID = UUID()
    let role: String
    let content: String
    let timestamp: String
}
