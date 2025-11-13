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
    
    /// Ritorna la bandierina dalla stringa "Italian 🇮🇹"
    static func flag(from language: String) -> String {
        // prende l’ultimo “token” (separa per spazi) – nelle tue stringhe è l’emoji
        if let last = language.split(separator: " ").last {
            let s = String(last)
            // semplice controllo che sia davvero un’emoji (opzionale)
            if s.unicodeScalars.contains(where: { $0.properties.isEmoji }) {
                return s
            }
        }
        return "🏳️" // fallback neutro
    }

    /// Ritorna il nome localizzato senza emoji (già lo usi, ma lascio anche qui)
    static func getLocalizedLanguageName(_ language: String) -> String {
        // Obtiene la traducción completa del idioma (ej: "Italiano 🇮🇹" en italiano)
        let localizedFullName = NSLocalizedString(language, comment: "")

        // Quita el emoji del final
        return localizedFullName.split(separator: " ")
            .dropLast() // rimuove l'emoji finale
            .joined(separator: " ")
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
