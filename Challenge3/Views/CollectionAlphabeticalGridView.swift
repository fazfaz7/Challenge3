import SwiftUI

struct CollectionAlphabeticalGridView: View {
    let phrases: [LearnElement]

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    private var groups: [(letter: String, phrases: [LearnElement])] {
        Dictionary(grouping: phrases) { phrase in
            String(phrase.userEntry.prefix(1)).uppercased()
        }
        .mapValues { phrases in
            phrases.sorted { $0.userEntry.localizedCaseInsensitiveCompare($1.userEntry) == .orderedAscending }
        }
        .sorted { $0.key < $1.key }
        .map { (letter: $0.key, phrases: $0.value) }
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(groups, id: \.letter) { group in
                NavigationLink {
                    AlphabetLetterWordsView(letter: group.letter, phrases: group.phrases)
                } label: {
                    AlphabetLetterCard(letter: group.letter, count: group.phrases.count)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 40)
    }
}

// MARK: - Letter Words View

struct AlphabetLetterWordsView: View {
    let letter: String
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
        .navigationTitle(letter)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Letter Card

struct AlphabetLetterCard: View {
    let letter: String
    let count: Int

    var body: some View {
        ZStack(alignment: .bottom) {
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

            VStack(spacing: 12) {
                Text(letter)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                Color(red: 0.1, green: 0.7, blue: 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("\(count) \(count == 1 ? "word" : "words")")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
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
