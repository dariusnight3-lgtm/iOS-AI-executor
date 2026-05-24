# 🚀 RONIX AI EXECUTOR

**Anti-Gravity iOS LLM Engine with Full Voice I/O, Task Automation & Function Calling**

![Status](https://img.shields.io/badge/status-production%20ready-brightgreen)
![Swift](https://img.shields.io/badge/swift-5.9+-orange)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- 🤖 **Claude 3.5 Sonnet** - State-of-the-art LLM integration
- 🎤 **Voice I/O** - Real-time speech recognition & synthesis
- ⚡ **Task Automation** - Multi-step autonomous execution
- 🔧 **Function Calling** - Extensible tool ecosystem
- 🌌 **Anti-Gravity Physics** - Custom particle engine
- 💬 **Streaming Chat** - Real-time conversation
- 🔒 **Privacy-First** - Local processing with optional cloud

## 🏗️ Architecture

```
RonixExecutor
├── LLMService (Claude API)
├── ToolExecutor (Function Calling)
├── VoiceManager (Speech I/O)
├── AntiGravityPhysics (Rendering)
└── ChatHistory (Conversation Context)
```

## 📦 Requirements

- iOS 17.0+
- Swift 5.9+
- Xcode 15.0+
- Anthropic API Key

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/dariusnight3-lgtm/iOS-AI-executor.git
cd iOS-AI-executor
```

### 2. Configure API Key
```bash
cp .env.example .env
export ANTHROPIC_API_KEY=your_key_here
```

### 3. Build for IPA
```bash
chmod +x build-ipa.sh
./build-ipa.sh
```

## 💬 Usage

### Chat with Claude
```swift
let executor = RonixExecutor.shared
await executor.chat("What is the meaning of life?")
```

### Voice Input
```swift
if let voiceText = await executor.voiceInput() {
    await executor.chat(voiceText)
}
```

### Task Automation
```swift
await executor.executeTask("search: AI trends, calculate: 2+2")
```

## 🔧 Built-in Tools

| Tool | Description |
|------|-------------|
| `search` | Search for information |
| `calculate` | Mathematical calculations |
| `datetime` | Current date/time operations |
| `notify` | Send notifications |

## 🌌 Anti-Gravity Physics

```swift
physics.addForceField(
    at: CGPoint(x: 100, y: 100),
    strength: 50,
    radius: 200,
    isRepulsive: true
)
```

## 📱 IPA Distribution

```bash
# Ad Hoc Build
xcodebuild -exportArchive \
  -archivePath build/ronix.xcarchive \
  -exportOptionsPlist export-options.plist \
  -exportPath build/ipa
```

## ⚙️ Configuration

```bash
ANTHROPIC_API_KEY=      # Your Anthropic API key
ANTHROPIC_MODEL=        # Model selection
MAX_TOKENS=             # Response token limit
```

## 📊 Performance

- **Response Time**: <500ms (with streaming)
- **Memory**: ~150MB active
- **Battery**: Optimized with background processing
- **Particles**: 60fps with 50+ particles

## 🔐 Security

✅ API keys from environment variables
✅ TLS 1.2+ for all network requests
✅ Local speech processing option
✅ No data persistence without consent

## 📝 License

MIT License - see LICENSE file

---

**Built with ❤️ for iOS developers who want AI superpowers**
