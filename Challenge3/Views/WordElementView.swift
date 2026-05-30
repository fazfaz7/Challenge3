import SwiftUI
import SwiftData

struct WordElementView: View {
    var phrase: LearnElement
    var isCollection: Bool = false
    @Environment(\.modelContext) var modelContext

    private let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)

    var body: some View {
        NavigationLink {
            if !isCollection { DetailView(phrase: phrase) }
            else { CollectionDetailView(phrase: phrase) }
        } label: {
            HStack {
                Text(phrase.userEntry)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .padding(.leading, 16 + 4)
            .background(.ultraThinMaterial, in: shape)
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.72, blue: 0.65),
                            Color(red: 0.1, green: 0.7, blue: 0.8)
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                    .frame(width: 4, height: 28)
                    .padding(.leading, 16)
            }
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                withAnimation {
                    modelContext.delete(phrase)
                    try? modelContext.save()
                }
            } label: { Label(isCollection ? "Delete from collection" : "Delete pending", systemImage: "trash.fill") }
        }
    }
}
