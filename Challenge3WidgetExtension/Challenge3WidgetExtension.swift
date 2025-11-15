//
//  Challenge3WidgetExtension.swift
//  Challenge3WidgetExtension
//
//  Created by Adrian Emmanuel Faz Mercado on 11/12/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct Challenge3WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.modelContext) var modelContext
    @Environment(\.widgetFamily) var widgetFamily

    @Query(
        filter: #Predicate { $0.isCompleted == true },
        sort: \LearnElement.dateAdded,
        order: .reverse,
        animation: .default
    ) var allPhrases: [LearnElement]

    // Filter phrases by selected language
    var filteredPhrases: [LearnElement] {
        guard let selectedLang = entry.configuration.selectedLanguage else {
            // No language selected, show all phrases
            return allPhrases
        }

        let languageId = selectedLang.id

        // If "All Languages" is selected, show all phrases
        if languageId == "All Languages" {
            return allPhrases
        }

        // Otherwise, filter by the selected language
        return allPhrases.filter { phrase in
            phrase.language == languageId
        }
    }

    var body: some View {
        if let myphrase = filteredPhrases.randomElement() {
            Group {
                switch widgetFamily {
                case .systemSmall:
                    SmallWidgetView(phrase: myphrase)
                case .systemMedium:
                    MediumWidgetView(phrase: myphrase)
                default:
                    MediumWidgetView(phrase: myphrase)
                }
            }
            .containerBackground(for: .widget) {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.72, blue: 0.65),
                        Color(red: 0.1, green: 0.7, blue: 0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        } else {
            // Empty state when no phrases available
            VStack(spacing: 12) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white.opacity(0.7))

                Text(NSLocalizedString("No words yet", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)

                Text(entry.configuration.selectedLanguage?.id == "All Languages" ? NSLocalizedString("Add words to see them here", comment: "") : "\(NSLocalizedString("Add some words in", comment: ""))\n\(entry.configuration.selectedLanguage?.name ?? NSLocalizedString("your language", comment: ""))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .containerBackground(for: .widget) {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.72, blue: 0.65),
                        Color(red: 0.1, green: 0.7, blue: 0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
}

// MARK: - Small Widget View
struct SmallWidgetView: View {
    let phrase: LearnElement
    
    var body: some View {
        ZStack {
            // Floating orb for depth
            GeometryReader { geometry in
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 80, height: 80)
                    .blur(radius: 25)
                    .offset(x: -20, y: -20)
                
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 60, height: 60)
                    .blur(radius: 20)
                    .offset(x: geometry.size.width - 40, y: geometry.size.height - 40)
            }
            
            VStack(spacing: 0) {
                // Flag in top-right corner
                HStack {
                    Spacer()
                    let flag = LanguageHelper.flag(from: phrase.language ?? "")
                    Text(flag)
                        .font(.system(size: 22))
                        .padding(6)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.15))
                        )
                }
                .padding(.top, 10)
                .padding(.trailing, 10)
                
                Spacer()
                
                // Word and explanation
                VStack(spacing: 6) {
                    Text(phrase.userEntry)
                        .font(.system(size: 24, weight: .bold))
                        .italic()
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 0.5)
                        .frame(maxWidth: 60)
                    
                    Text(phrase.explanation)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal, 12)
                
                Spacer()
            }
        }
    }
}

// MARK: - Medium Widget View
struct MediumWidgetView: View {
    let phrase: LearnElement
    
    var body: some View {
        ZStack {
            // Floating orbs para profundidad
            GeometryReader { geometry in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .blur(radius: 30)
                    .offset(x: -40, y: -40)
                
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 100, height: 100)
                    .blur(radius: 25)
                    .offset(x: geometry.size.width - 60, y: geometry.size.height - 60)
            }
            
            // Contenido
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(NSLocalizedString("DAILY WORD", comment: ""))
                        .font(.system(size: 9, weight: .bold))
                        .tracking(0.5)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                        )
                    
                    Spacer()
                    
                    let flag = LanguageHelper.flag(from: phrase.language ?? "")
                    Text(flag)
                        .font(.system(size: 20))
                        .padding(6)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        )
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                Spacer()
                
                // Palabra y explicación
                VStack(spacing: 8) {
                    Text(phrase.userEntry)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .italic()
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.75)
                        .multilineTextAlignment(.center)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 0.5)
                        .frame(maxWidth: 100)
                    
                    Text(phrase.explanation)
                        .font(.callout)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
}

struct Challenge3WidgetExtension: Widget {
    let kind: String = "Challenge3WidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Challenge3WidgetExtensionEntryView(entry: entry)
                .modelContainer(for: [LearnElement.self, Category.self])
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var allLanguages: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedLanguage = LanguageEntity(id: "All Languages", name: NSLocalizedString("All Languages", comment: ""))
        return intent
    }

    fileprivate static var italian: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.selectedLanguage = LanguageEntity(id: "Italian 🇮🇹", name: "Italian 🇮🇹")
        return intent
    }
}

#Preview(as: .systemMedium) {
    Challenge3WidgetExtension()
} timeline: {
    SimpleEntry(date: .now, configuration: .allLanguages)
    SimpleEntry(date: .now, configuration: .italian)
}
