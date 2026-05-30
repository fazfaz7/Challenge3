import SwiftUI
import SwiftData

struct AddLanguageView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Italian 🇮🇹"
    @EnvironmentObject var languageStore: LanguageStore
    @State private var customLanguageName: String = ""
    @FocusState private var isCustomFieldFocused: Bool

    var availableLanguages: [String] {
        LanguageStore.knownLanguages.filter { lang in
            !languageStore.userLanguages.contains(where: { $0 == lang })
        }
    }

    private var customLanguageEntry: String {
        customLanguageName.trimmingCharacters(in: .whitespaces) + " 🌐"
    }

    private var canAddCustom: Bool {
        let trimmed = customLanguageName.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && !languageStore.userLanguages.contains(customLanguageEntry)
    }

    private func addCustomLanguage() {
        languageStore.addLanguage(customLanguageEntry)
        selectedLanguage = customLanguageEntry
        dismiss()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text(LocalizedStringKey("Select a language you want to learn"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 24)

                    ScrollView {
                            VStack(spacing: 12) {
                                if availableLanguages.isEmpty {
                                    HStack(spacing: 10) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.accentColor)
                                        Text("All preset languages added!")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 8)
                                }

                                ForEach(availableLanguages, id: \.self) { language in
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            languageStore.addLanguage(language)
                                            selectedLanguage = language
                                        }
                                        dismiss()
                                    } label: {
                                        HStack(spacing: 16) {
                                            Text(LanguageHelper.flag(from: language))
                                                .font(.system(size: 36))

                                            Text(LanguageHelper.getLocalizedLanguageName(language).capitalized)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)

                                            Spacer()

                                            Image(systemName: "plus.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(.accentColor)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
                                    }
                                    .buttonStyle(.plain)
                                }

                                // Custom language section
                                VStack(spacing: 10) {
                                    HStack {
                                        Text("Other")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                            .tracking(0.6)
                                        Spacer()
                                    }
                                    .padding(.top, 8)

                                    HStack(spacing: 12) {
                                        Text("🌐")
                                            .font(.system(size: 32))

                                        TextField("e.g. Catalan, Latin...", text: $customLanguageName)
                                            .focused($isCustomFieldFocused)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .submitLabel(.done)
                                            .onSubmit {
                                                if canAddCustom {
                                                    addCustomLanguage()
                                                }
                                            }

                                        Button {
                                            addCustomLanguage()
                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(canAddCustom ? .accentColor : .secondary.opacity(0.4))
                                        }
                                        .disabled(!canAddCustom)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)

                                    Text("Audio playback is not available for custom languages.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 4)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                        }
                }
            }
            .navigationTitle("Add Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}
