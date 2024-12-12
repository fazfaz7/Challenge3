//
//  Challenge3WidgetExtensionLiveActivity.swift
//  Challenge3WidgetExtension
//
//  Created by Adrian Emmanuel Faz Mercado on 11/12/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Challenge3WidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Challenge3WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Challenge3WidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Challenge3WidgetExtensionAttributes {
    fileprivate static var preview: Challenge3WidgetExtensionAttributes {
        Challenge3WidgetExtensionAttributes(name: "World")
    }
}

extension Challenge3WidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: Challenge3WidgetExtensionAttributes.ContentState {
        Challenge3WidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Challenge3WidgetExtensionAttributes.ContentState {
         Challenge3WidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Challenge3WidgetExtensionAttributes.preview) {
   Challenge3WidgetExtensionLiveActivity()
} contentStates: {
    Challenge3WidgetExtensionAttributes.ContentState.smiley
    Challenge3WidgetExtensionAttributes.ContentState.starEyes
}
