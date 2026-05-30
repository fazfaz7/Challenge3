//
//  LanguageStore.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 28/07/25.
//

import Foundation

final class LanguageStore: ObservableObject {
    static let shared = LanguageStore()

    static let knownLanguages = [
        "Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪",
        "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇧🇷", "Spanish 🇪🇸", "Turkish 🇹🇷"
    ]

    static func supportsTextToSpeech(_ language: String) -> Bool {
        knownLanguages.contains(language)
    }
    
    @Published var userLanguages: [String] = []
    private let fileURL: URL
    
    private init() {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        fileURL = documentsDirectory.appendingPathComponent("user_languages.json")
        loadLanguages()
    }
    
    private func loadLanguages() {
        do {
            let data = try Data(contentsOf: fileURL)
            userLanguages = try JSONDecoder().decode([String].self, from: data)
        } catch {
            userLanguages = [] // Start with empty array
        }
    }
    
    func saveLanguages() {
        do {
            let data = try JSONEncoder().encode(userLanguages)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Error saving languages: \(error)")
        }
    }
    
    func addLanguage(_ language: String) {
        if !userLanguages.contains(language) {
            userLanguages.append(language)
            saveLanguages()
        }
    }
    
    func removeLanguage(_ language: String) {
        if let index = userLanguages.firstIndex(of: language) {
            userLanguages.remove(at: index)
            saveLanguages()
        }
    }
}
