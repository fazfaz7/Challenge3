import SwiftUI
import SwiftData

struct NewPhraseView: View {
    @Binding var newPhraseText: String
    @Binding var showNewPhrase: Bool
    @Binding var newType: Int

    @Environment(\.modelContext) var modelContext
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"

    @FocusState private var isFocused: Bool
    let maxCharacters = 50

    private var trimmed: String { newPhraseText.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var remaining: Int { max(0, maxCharacters - newPhraseText.count) }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack(spacing: 10) {
                Text(LocalizedStringKey(newType == 1 ? "Add New Expression" : "How to say…?"))
                    .font(.title2).fontWeight(.semibold)
                ProgressRing(progress: Double(newPhraseText.count)/Double(maxCharacters))
            }

            Text(LocalizedStringKey(newType == 1
                 ? "Found a word or phrase you don't understand? Save it to review later."
                 : "Write what you want to say in the language you're learning."))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                Image(systemName: "pencil")
                    .foregroundStyle(.secondary)

                TextField(LocalizedStringKey("Type the word or phrase…"), text: $newPhraseText)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit { add() }
                    .onChange(of: newPhraseText) { old, new in
                        if new.count > maxCharacters { newPhraseText = String(new.prefix(maxCharacters)) }
                    }

                if !newPhraseText.isEmpty {
                    Button {
                        newPhraseText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(.separator).opacity(0.6), lineWidth: 0.5)
            )

            HStack {
                Spacer()
                Text("\(remaining)")
                    .font(.caption).monospacedDigit()
                    .foregroundStyle(remaining == 0 ? .red : .secondary)
            }

        }
        .padding(20)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(action: add) {
                    Text(LocalizedStringKey("Add"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Group {
                            if trimmed.isEmpty {
                                Color.gray.opacity(0.4)
                            } else {
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.08, green: 0.72, blue: 0.65),
                                        Color(red: 0.1, green: 0.7, blue: 0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: trimmed.isEmpty ? .clear : .accentColor.opacity(0.3),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                }
                .disabled(trimmed.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.thinMaterial)
        }
        .onAppear { isFocused = true }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(LocalizedStringKey("Cancel")) { showNewPhrase = false }
            }
        }
    }

    private func add() {
        let text = trimmed
        guard !text.isEmpty else { return }
        let element = LearnElement(
            learnType: newType == 1 ? .newPhrase : .howToSay,
            userEntry: text, explanation: "", language: selectedLanguage
        )
        withAnimation { modelContext.insert(element) }
        newPhraseText = ""
        showNewPhrase = false
    }
}

private struct ProgressRing: View {
    var progress: Double
    var body: some View {
        ZStack {
            Circle().stroke(Color(.separator).opacity(0.6), lineWidth: 3)
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(.tint, style: .init(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 14, height: 14)
        .accessibilityHidden(true)
    }
}
