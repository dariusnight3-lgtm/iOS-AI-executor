import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    private let executor: RonixExecutor
    
    init(executor: RonixExecutor = .shared) {
        self.executor = executor
    }
    
    func sendMessage() async {
        guard !inputText.isEmpty else { return }
        
        isLoading = true
        await executor.chat(inputText)
        inputText = ""
        isLoading = false
    }
}
