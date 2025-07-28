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
    var language: String?
    
    init(learnType: elementType = .newPhrase, userEntry: String = "", explanation: String = "", language: String = "Italian 🇮🇹") {
        self.learnType = learnType
        self.userEntry = userEntry
        self.explanation = explanation
        self.dateAdded = .now
        self.language = language
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



enum AppLocale: String {
    case english = "en"
    case spanish = "es"
    case italian = "it"
    
    static var current: AppLocale {
        switch Locale.current.language.languageCode?.identifier {
        case "es": return .spanish
        case "it": return .italian
        default: return .english
        }
    }
}

struct LanguageHelper {
    
    static func getLocalizedLanguageName(_ language: String) -> String {
        let rawName = language.components(separatedBy: " ").dropLast().joined(separator: " ") // Removes the emoji

        let localizedNames: [String: [AppLocale: String]] = [
            "Italian": [.english: "Italian", .spanish: "italiano", .italian: "italiano"],
            "Spanish": [.english: "Spanish", .spanish: "español", .italian: "spagnolo"],
            "English": [.english: "English", .spanish: "inglés", .italian: "inglese"],
            "French": [.english: "French", .spanish: "francés", .italian: "francese"],
            "German": [.english: "German", .spanish: "alemán", .italian: "tedesco"],
            "Portuguese": [.english: "Portuguese", .spanish: "portugués", .italian: "portoghese"],
            "Chinese": [.english: "Chinese", .spanish: "chino", .italian: "cinese"],
            "Japanese": [.english: "Japanese", .spanish: "japonés", .italian: "giapponese"],
            "Turkish": [.english: "Turkish", .spanish: "turco", .italian: "turco"]
        ]
        
        return localizedNames[rawName]?[AppLocale.current] ?? rawName
    }
    
    static func getLocalizedLearnerTitle(for language: String) -> String {
        let localizedLang = getLocalizedLanguageName(language)
        
        switch AppLocale.current {
        case .english:
            return "\(localizedLang)"
        case .spanish:
            return "\(localizedLang)".capitalized
        case .italian:
            return "\(localizedLang)".capitalized
        }
    }
}
