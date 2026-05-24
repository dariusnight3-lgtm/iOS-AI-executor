import SwiftUI
import AVFoundation
import Speech

@main
struct IOSAIExecutorApp: App {
    @State private var executor: RonixExecutor = RonixExecutor.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(executor)
                .onAppear {
                    executor.initialize()
                }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var executor: RonixExecutor
    @State private var userInput: String = ""
    @State private var isListening: Bool = false
    @State private var showAntiGravity: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black, .gray]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                VStack {
                    Text("RONIX AI EXECUTOR")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                    Text("Anti-Gravity LLM Engine")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(executor.chatHistory.indices, id: \.self) { index in
                                ChatMessageView(
                                    message: executor.chatHistory[index],
                                    isUser: executor.chatHistory[index].role == "user"
                                )
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .cornerRadius(12)
                
                if showAntiGravity {
                    AntiGravityView()
                        .frame(height: 150)
                        .cornerRadius(12)
                }
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        TextField("Ask me anything...", text: $userInput)
                            .textFieldStyle(.roundedBorder)
                            .foregroundColor(.white)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.cyan)
                        }
                        .disabled(userInput.isEmpty)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: toggleVoiceInput) {
                            HStack {
                                Image(systemName: isListening ? "stop.fill" : "mic.fill")
                                Text(isListening ? "Stop" : "Voice")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(isListening ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: { showAntiGravity.toggle() }) {
                            HStack {
                                Image(systemName: "waveform.circle")
                                Text("Physics")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: executeTask) {
                            HStack {
                                Image(systemName: "bolt.fill")
                                Text("Execute")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        Task {
            await executor.chat(userInput)
            userInput = ""
        }
    }
    
    private func toggleVoiceInput() {
        isListening.toggle()
        if isListening {
            Task {
                if let voiceText = await executor.voiceInput() {
                    userInput = voiceText
                }
                isListening = false
            }
        }
    }
    
    private func executeTask() {
        Task {
            await executor.executeTask(userInput)
        }
    }
}

struct ChatMessageView: View {
    let message: ChatMessage
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            VStack(alignment: .leading) {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(.white)
                
                if !message.timestamp.isEmpty {
                    Text(message.timestamp)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding(12)
            .background(isUser ? Color.cyan.opacity(0.3) : Color.green.opacity(0.2))
            .cornerRadius(8)
            
            if !isUser { Spacer() }
        }
    }
}

struct AntiGravityView: View {
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(particles.indices, id: \.self) { index in
                Circle()
                    .fill(Color.cyan.opacity(Double(particles[index].opacity)))
                    .frame(width: particles[index].size)
                    .position(particles[index].position)
            }
        }
        .onAppear {
            initializeParticles()
        }
        .onReceive(timer) { _ in
            updateParticles()
        }
    }
    
    private func initializeParticles() {
        particles = (0..<50).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...300),
                    y: CGFloat.random(in: 0...150)
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: -2...2),
                    dy: CGFloat.random(in: -2...2)
                ),
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.3...1.0)
            )
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            var particle = particles[i]
            particle.velocity.dy += 0.1
            particle.position.x += particle.velocity.dx
            particle.position.y += particle.velocity.dy
            
            if particle.position.y > 150 {
                particle.position.y = 0
                particle.velocity.dy *= -0.5
            }
            
            particle.opacity -= 0.005
            if particle.opacity <= 0 {
                particle.opacity = 1.0
                particle.position.y = 0
            }
            
            particles[i] = particle
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var size: CGFloat
    var opacity: Double
}

#Preview {
    ContentView()
        .environmentObject(RonixExecutor.shared)
}
