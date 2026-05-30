import AVFoundation

class TextToSpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0

        if language.contains("Italian") {
            utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        } else if language.contains("Spanish") {
            utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        } else if language.contains("French") {
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        } else if language.contains("German") {
            utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        } else if language.contains("Chinese") {
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        } else if language.contains("Japanese") {
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        } else if language.contains("Portuguese") {
            utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        } else if language.contains("Turkish") {
            utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        } else if language.contains("English") {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        synthesizer.speak(utterance)
    }
}

class TextToSpeechViewModel: ObservableObject {
    private let textToSpeechService: TextToSpeechService

    init(textToSpeechService: TextToSpeechService) {
        self.textToSpeechService = textToSpeechService
    }

    func speak(text: String, language: String) {
        textToSpeechService.speak(text: text, language: language)
    }
}
