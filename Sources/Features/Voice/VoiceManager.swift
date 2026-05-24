import AVFoundation
import Speech

class VoiceManager: NSObject, AVAudioRecorderDelegate {
    static let shared = VoiceManager()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var audioRecorder: AVAudioRecorder?
    
    func speak(_ text: String, voice: AVSpeechSynthesisVoice? = nil) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        if let voice = voice {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    func getAvailableVoices() -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices()
    }
}
