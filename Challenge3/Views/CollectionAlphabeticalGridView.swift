import SwiftUI

struct CollectionAlphabeticalGridView: View {
    let phrases: [LearnElement]

    private var sections: [(letter: String, phrases: [LearnElement])] {
        Dictionary(grouping: phrases) { phrase in
            String(phrase.userEntry.prefix(1)).uppercased()
        }
        .mapValues { $0.sorted { $0.userEntry.localizedCaseInsensitiveCompare($1.userEntry) == .orderedAscending } }
        .sorted { $0.key < $1.key }
        .map { (letter: $0.key, phrases: $0.value) }
    }

    var body: some View {
        VStack(spacing: 24) {
            ForEach(sections, id: \.letter) { section in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(section.letter)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(section.phrases.count)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.secondary.opacity(0.12)))
                    }
                    .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        ForEach(section.phrases, id: \.id) { phrase in
                            NavigationLink {
                                CollectionDetailView(phrase: phrase)
                            } label: {
                                WordElementView(phrase: phrase, isCollection: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 40)
    }
}
