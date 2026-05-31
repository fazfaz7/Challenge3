import SwiftUI

struct CollectionCategoryGridView: View {
    let phrases: [LearnElement]
    @Binding var selectedCategory: String?

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    private var groups: [(title: String, emoji: String, phrases: [LearnElement])] {
        let grouped = Dictionary(grouping: phrases) { phrase -> String in
            if let cat = phrase.category { return "\(cat.emoji)|\(cat.name)" }
            return "📝|No Category"
        }
        return grouped
            .map { key, phrases in
                let parts = key.split(separator: "|", maxSplits: 1).map(String.init)
                return (title: parts.last ?? key, emoji: parts.first ?? "📝", phrases: phrases)
            }
            .sorted { lhs, rhs in
                if lhs.title == "No Category" { return false }
                if rhs.title == "No Category" { return true }
                return lhs.title < rhs.title
            }
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(groups, id: \.title) { group in
                NavigationLink {
                    CategoryWordsView(
                        emoji: group.emoji,
                        title: group.title,
                        phrases: group.phrases.sorted {
                            $0.userEntry.localizedCaseInsensitiveCompare($1.userEntry) == .orderedAscending
                        }
                    )
                } label: {
                    CategoryCard(
                        emoji: group.emoji,
                        title: group.title,
                        count: group.phrases.count,
                        isSelected: false
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 40)
    }
}

// MARK: - Category Words View

struct CategoryWordsView: View {
    let emoji: String
    let title: String
    let phrases: [LearnElement]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(phrases, id: \.id) { phrase in
                        NavigationLink {
                            CollectionDetailView(phrase: phrase)
                        } label: {
                            WordElementView(phrase: phrase, isCollection: true)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("\(emoji) \(title)")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let emoji: String
    let title: String
    let count: Int
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            // Stacked cards — neutral grey depth
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground).opacity(0.6))
                .rotationEffect(.degrees(3.5))
                .offset(x: 4, y: -3)
                .scaleEffect(0.95)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)

            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground).opacity(0.8))
                .rotationEffect(.degrees(-2))
                .offset(x: -2, y: -1.5)
                .scaleEffect(0.97)
                .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)

            // Main card
            VStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 42))

                VStack(spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    Text("\(count) \(count == 1 ? "word" : "words")")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }

            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }
}
