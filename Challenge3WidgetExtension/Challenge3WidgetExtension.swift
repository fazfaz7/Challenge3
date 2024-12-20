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
    //@Query(filter: #Predicate { $0.isCompleted == true }) var testPhrases: [LearnElement]
    @Query(
        filter: #Predicate { $0.isCompleted == true },
        sort: \LearnElement.dateAdded,
        order: .reverse,
        animation: .default
    ) var testPhrases: [LearnElement]

    var body: some View {

        VStack(spacing: 5) {
                
            if let myphrase = testPhrases.randomElement() {
                Text("\(myphrase.userEntry)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundStyle(.white)
                
                HStack {
                    Text(myphrase.explanation)
                        .font(.callout)
                        .foregroundStyle(.white)
                }
            }
                
            }.containerBackground(for: .widget){

                LinearGradient(colors: [.darkaccent,.accent], startPoint: .top, endPoint: .bottom)
                    
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
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    Challenge3WidgetExtension()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
