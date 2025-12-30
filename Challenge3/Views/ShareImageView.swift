//
//  ShareImageView.swift
//  Challenge3
//
//  Created for Instagram story sharing feature
//

import SwiftUI

struct ShareImageView: View {
    let phrase: String
    let meaning: String
    let languageFlag: String

    var body: some View {
        ZStack {
            // Beautiful gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.72, blue: 0.65),
                    Color(red: 0.1, green: 0.7, blue: 0.8),
                    Color(red: 0.12, green: 0.65, blue: 0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Content
            VStack(spacing: 0) {
                Spacer()

                // Language flag
                Text(languageFlag)
                    .font(.system(size: 180))
                    .padding(.bottom, 80)

                // Main phrase
                Text(phrase)
                    .font(.system(size: 115, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 80)
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)

                Spacer()
                    .frame(height: 50)

                // Meaning/Translation
                Text(meaning)
                    .font(.system(size: 75, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 100)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                Spacer()

                // Watermark
                Text("ItMeans")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.bottom, 100)
            }
        }
        .frame(width: 1080, height: 1920) // Instagram story size
    }
}

#Preview {
    ShareImageView(
        phrase: "¿Cómo estás?",
        meaning: "How are you?",
        languageFlag: "🇪🇸"
    )
}
