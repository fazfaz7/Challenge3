import SwiftUI

struct SectionSettingsView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Italian 🇮🇹"
    @Environment(\.dismiss) var dismiss

    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇧🇷", "Spanish 🇪🇸", "Turkish 🇹🇷"]

    @EnvironmentObject var languageStore: LanguageStore
    @State private var showAddLanguage = false
    @State private var languageToDelete: String?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(LocalizedStringKey("Nickname"))) {
                    TextField(LocalizedStringKey("Enter your nickname"), text: $userName)
                }

                Section(header: Text(LocalizedStringKey("Languages you are learning"))) {
                    ForEach(languageStore.userLanguages, id: \.self) { language in
                        HStack {
                            Text(LocalizedStringKey(language))
                            Spacer()
                            if language == selectedLanguage {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedLanguage = language
                        }
                    }.onDelete { indexSet in
                        guard let index = indexSet.first else { return }
                        languageToDelete = languageStore.userLanguages[index]
                        languageStore.removeLanguage(languageToDelete!)
                        if selectedLanguage == languageToDelete {
                            selectedLanguage = languageStore.userLanguages.first ?? ""
                        }
                    }
                }

                Button {
                    showAddLanguage = true
                } label: {
                    Text(LocalizedStringKey("Add Language"))
                }
            }
            .navigationTitle(LocalizedStringKey("Settings"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(LocalizedStringKey("Done")) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddLanguage) {
                AddLanguageView()
            }
        }
    }
}
