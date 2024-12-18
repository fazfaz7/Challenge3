//
//  SpeechRecognizer.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 11/12/24.
//

import Foundation
import AVFoundation
import Speech

@Observable
class SpeechRecognizer {
    
    // 1.
    var recognizedText: String = "No speech recognized"
    var startedListening: Bool = false
    // 2.
    var audioEngine: AVAudioEngine!
    // 3.
    var speechRecognizer: SFSpeechRecognizer!
    // 4.
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    // 5.
    var recognitionTask: SFSpeechRecognitionTask!
    
    init() {
        setupSpeechRecognition()
    }
    
    func setupSpeechRecognition() {
        // 1.
        audioEngine = AVAudioEngine()
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "it-IT"))

        
        // 2.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied, .restricted, .notDetermined:
                    print("Speech recognition not authorized")
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
    }
    
    func startListening() {
            // 1.
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            recognitionRequest.shouldReportPartialResults = true
            startedListening = true
            
            // 2.
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            
            // 3.
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
                self.recognitionRequest.append(buffer)
            }
            
            // 4.
            audioEngine.prepare()
            try! audioEngine.start()
            
            // 5.
            speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    Task {
                        self.recognizedText = result.bestTranscription.formattedString
                    }
                
                }
                
                if error != nil || result?.isFinal == true {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                        
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
        }
    
    func stopListening() {
        // 1.
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        // 2.
        recognitionRequest.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        startedListening = false
    }
    
}
