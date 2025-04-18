//
//  LearnElement.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import Foundation
import SwiftData

enum elementType: Codable {
    case newPhrase
    case howToSay
}

@Model
class LearnElement: ObservableObject {
    var id = UUID()
    var learnType: elementType
    var userEntry: String
    var explanation: String
    var dateAdded: Date
    var isCompleted: Bool = false
    var category: Category? = nil
    
    init(learnType: elementType = .newPhrase, userEntry: String = "", explanation: String = "") {
        self.learnType = learnType
        self.userEntry = userEntry
        self.explanation = explanation
        self.dateAdded = .now
    }
    
}

@Model
class Category: Hashable {
    var id = UUID()
    var name: String
    var emoji: String
    var dateAdded: Date
    
    init(name: String = "", emoji: String = "") {
        self.name = name
        self.emoji = emoji
        self.dateAdded = .now
    }
}



var categories: [Category] = [
    Category(name: "Daily Phrases", emoji: "☀️"),
    Category(name: "Transportation", emoji: "🚘"),
    Category(name: "Food", emoji: "🍕"),
    Category(name: "Shopping", emoji: "🛍️"),
    Category(name: "Slang", emoji: "😂")
]

struct LanguageOption: Identifiable, Hashable {
    let id = UUID()
    let nameKey: String // clave para Localizable.strings, por ejemplo: "italian"
    let displayName: String // nombre con emoji para mostrar: "Italian 🇮🇹"
    let code: String // para text-to-speech y lógica interna, ej: "it-IT"
}

let availableLanguages: [LanguageOption] = [
    LanguageOption(nameKey: "chinese", displayName: "Chinese 🇨🇳", code: "zh-CN"),
    LanguageOption(nameKey: "english", displayName: "English 🇬🇧", code: "en-GB"),
    LanguageOption(nameKey: "french", displayName: "French 🇫🇷", code: "fr-FR"),
    LanguageOption(nameKey: "german", displayName: "German 🇩🇪", code: "de-DE"),
    LanguageOption(nameKey: "italian", displayName: "Italian 🇮🇹", code: "it-IT"),
    LanguageOption(nameKey: "japanese", displayName: "Japanese 🇯🇵", code: "ja-JP"),
    LanguageOption(nameKey: "portuguese", displayName: "Portuguese 🇵🇹", code: "pt-PT"),
    LanguageOption(nameKey: "spanish", displayName: "Spanish 🇪🇸", code: "es-MX"),
    LanguageOption(nameKey: "turkish", displayName: "Turkish 🇹🇷", code: "tr-TR")
]
