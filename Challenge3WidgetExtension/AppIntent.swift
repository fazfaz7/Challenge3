//
//  AppIntent.swift
//  Challenge3WidgetExtension
//
//  Created by Adrian Emmanuel Faz Mercado on 11/12/24.
//

import WidgetKit
import AppIntents
import Foundation

// Entity representing a language choice
struct LanguageEntity: AppEntity {
    let id: String
    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Language"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static var defaultQuery = LanguageQuery()
}

// Query to provide available languages
struct LanguageQuery: EntityQuery {
    // All available languages
    static let allAvailableLanguages = [
        "All Languages",
        "Chinese 🇨🇳",
        "English 🇬🇧",
        "French 🇫🇷",
        "German 🇩🇪",
        "Italian 🇮🇹",
        "Japanese 🇯🇵",
        "Portuguese 🇵🇹",
        "Spanish 🇪🇸",
        "Turkish 🇹🇷"
    ]

    func entities(for identifiers: [String]) async throws -> [LanguageEntity] {
        return identifiers.compactMap { id in
            if LanguageQuery.allAvailableLanguages.contains(id) {
                // Keep ID as original key, but display localized name
                let displayName = id == "All Languages" ? NSLocalizedString("All Languages", comment: "") : id
                return LanguageEntity(id: id, name: displayName)
            }
            return nil
        }
    }

    func suggestedEntities() async throws -> [LanguageEntity] {
        // Show all available languages
        return LanguageQuery.allAvailableLanguages.map { lang in
            let displayName = lang == "All Languages" ? NSLocalizedString("All Languages", comment: "") : lang
            return LanguageEntity(id: lang, name: displayName)
        }
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Widget Configuration" }
    static var description: IntentDescription { "Choose which language to display in your widget." }

    @Parameter(title: "Language")
    var selectedLanguage: LanguageEntity?

    static var parameterSummary: some ParameterSummary {
        Summary("Display words in \(\.$selectedLanguage)")
    }
}
