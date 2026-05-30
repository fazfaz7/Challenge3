import AVFoundation

class TextToSpeechService: ObservableObject {
    static let shared = TextToSpeechService()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
    }

    private static let languageCodes: [String: String] = [
        "Italian": "it-IT",
        "Spanish": "es-MX",
        "French": "fr-FR",
        "German": "de-DE",
        "Chinese": "zh-CN",
        "Japanese": "ja-JP",
        "Portuguese": "pt-BR",
        "Turkish": "tr-TR",
        "English": "en-GB"
    ]

    func speak(text: String, language: String) {
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = resolveVoice(for: language)
        synthesizer.speak(utterance)
    }

    private func resolveVoice(for language: String) -> AVSpeechSynthesisVoice? {
        let langCode = Self.languageCodes.first(where: { language.contains($0.key) })?.value ?? "en-US"

        let allVoices = AVSpeechSynthesisVoice.speechVoices()
        return allVoices.first { $0.language == langCode && $0.quality == .premium }
            ?? allVoices.first { $0.language == langCode && $0.quality == .enhanced }
            ?? AVSpeechSynthesisVoice(language: langCode)
    }
}

// Kept for backwards compatibility with existing views
class TextToSpeechViewModel: ObservableObject {
    let service: TextToSpeechService

    init(textToSpeechService: TextToSpeechService = .shared) {
        self.service = textToSpeechService
    }

    func speak(text: String, language: String) {
        service.speak(text: text, language: language)
    }
}
