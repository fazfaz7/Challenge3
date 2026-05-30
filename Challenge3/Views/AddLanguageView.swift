import SwiftUI

struct AddLanguageView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Italian 🇮🇹"
    @EnvironmentObject var languageStore: LanguageStore

    let allLanguages = [
        "Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪",
        "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇧🇷", "Spanish 🇪🇸", "Turkish 🇹🇷"
    ]

    var availableLanguages: [String] {
        allLanguages.filter { lang in
            !languageStore.userLanguages.contains(where: { $0 == lang })
        }
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

                    if availableLanguages.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()

                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.accentColor)

                            VStack(spacing: 8) {
                                Text(LocalizedStringKey("All languages added!"))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)

                                Text(LocalizedStringKey("You're learning all available languages"))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }

                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)

                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
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
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                        }
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
