# iOS AI Executor (Ronix) - Architecture Documentation

## Overview
A production-grade iOS AI executor featuring Claude LLM integration, anti-gravity physics rendering, voice I/O, task automation, and extensible tool calling.

## Core Architecture

### 1. **RonixExecutor** (Main Engine)
- Central coordinator for all AI operations
- Manages chat history, task execution, and voice I/O
- Singleton pattern for app-wide access
- Observable for reactive UI updates

### 2. **LLMService** (Claude Integration)
- Handles streaming HTTP communication with Anthropic API
- Manages conversation context and token limits
- Supports function calling for tool invocation
- Async/await concurrency model

### 3. **ToolExecutor** (Function Calling)
- Registry pattern for extensible tools
- Built-in tools: search, calculate, datetime, notifications
- Custom tool registration at runtime
- Task automation with multi-step execution

### 4. **AntiGravityPhysics** (Physics Engine)
- Custom force field simulation
- Particle system with physics
- Configurable gravity and repulsive fields
- Real-time delta-time calculations

### 5. **VoiceManager** (Voice I/O)
- Speech recognition (SFSpeechRecognizer)
- Text-to-speech synthesis (AVSpeechSynthesizer)
- Multiple voice personalities
- Microphone permission handling

## Data Flow

```
User Input (Voice/Text)
    ↓
RonixExecutor.chat()
    ↓
LLMService.streamChat()
    ↓
Claude API Response
    ↓
Function Call Detection
    ↓
ToolExecutor.execute()
    ↓
Tool Result
    ↓
Claude Processes Result
    ↓
Chat History Update
    ↓
UI Re-render (SwiftUI Observable)
```

## Technologies

### Frameworks
- **SwiftUI** - Modern declarative UI
- **Combine** - Reactive programming
- **Swift Concurrency** - Async/await
- **AVFoundation** - Audio/video handling
- **Speech** - Speech recognition
- **CoreGraphics** - Physics rendering

## Building for IPA

### Prerequisites
- Xcode 15+
- iOS 17 deployment target
- Valid Apple Developer account
- Provisioning profiles configured

### Build Steps
1. Configure signing: Project → Signing & Capabilities
2. Set bundle identifier: `com.yourcompany.ronix-executor`
3. Select Release configuration
4. Product → Archive
5. Distribute App → Ad Hoc/App Store
