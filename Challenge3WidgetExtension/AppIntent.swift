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

// Entity representing a time range choice
struct TimeRangeEntity: AppEntity {
    let id: String
    let name: String
    let days: Int? // nil means "all time"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Time Range"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static var defaultQuery = TimeRangeQuery()
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

// Query to provide available time ranges
struct TimeRangeQuery: EntityQuery {
    // All available time ranges
    static let allTimeRanges: [(id: String, days: Int?)] = [
        ("All time", nil),
        ("Last 7 days", 7),
        ("Last 30 days", 30),
        ("Last 3 months", 90)
    ]

    func entities(for identifiers: [String]) async throws -> [TimeRangeEntity] {
        return identifiers.compactMap { id in
            if let timeRange = TimeRangeQuery.allTimeRanges.first(where: { $0.id == id }) {
                let displayName = NSLocalizedString(timeRange.id, comment: "")
                return TimeRangeEntity(id: timeRange.id, name: displayName, days: timeRange.days)
            }
            return nil
        }
    }

    func suggestedEntities() async throws -> [TimeRangeEntity] {
        return TimeRangeQuery.allTimeRanges.map { timeRange in
            let displayName = NSLocalizedString(timeRange.id, comment: "")
            return TimeRangeEntity(id: timeRange.id, name: displayName, days: timeRange.days)
        }
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Widget Configuration" }
    static var description: IntentDescription { "Choose which language and time range to display in your widget." }

    @Parameter(title: "Language")
    var selectedLanguage: LanguageEntity?

    @Parameter(title: "Time Range")
    var selectedTimeRange: TimeRangeEntity?

    static var parameterSummary: some ParameterSummary {
        Summary("Display words in \(\.$selectedLanguage) from \(\.$selectedTimeRange)")
    }
}
