//
//  ContentView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import SwiftUI
import SwiftData
import NaturalLanguage
import WidgetKit

struct ContentView: View {
    @State var showNewPhrase: Bool = false
    @State var newPhraseText: String = ""
    @State var newType: Int = 1
    @Query(sort: \LearnElement.dateAdded, order: .reverse) var allPhrases: [LearnElement]
    
    var testPhrases: [LearnElement] {
        allPhrases.filter { !$0.isCompleted && $0.language == selectedLanguage }
    }
    
    @State var phrases: [String] = ["Mi raccomando", "Lascia perdere?", "In bocca al lupo", "Merluzzo", "Suino/Maiale?", "Stupidino"]
    @Environment(\.modelContext) var modelContext
    @Query(
        sort: \Category.dateAdded,
        animation: .default
    ) var myCategories: [Category]
    
    @State var newPhrasesExpanded: Bool = false
    @State var howToSayExpanded: Bool = false
    @AppStorage("userName") private var userName: String = "No name set"
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true
    @State private var isPresenting = true
    @State private var isPresentingInfo = false
    @State private var isPresentingSettings = false
    @State private var selectedSegment = 0
    @AppStorage("hasInsertedDefaultCategories") private var hasInsertedDefaultCategories: Bool = false
    @AppStorage("hasMigratedLanguages") private var hasMigratedLanguages = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var languageStore: LanguageStore
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                // Background gradient
                Color(.systemGroupedBackground).ignoresSafeArea()
                .ignoresSafeArea()
                
                
                VStack {
                    // NUEVO HEADER - iOS 18 Style
                    VStack(alignment: .leading, spacing: 12) {
                        // Language selector con flag y nombre
                        HStack(spacing: 12) {
                            Text(LanguageHelper.flag(from: selectedLanguage))  // ✅ Dinámico
                                .font(.system(size: 48))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Menu {
                                    ForEach(languageStore.userLanguages, id: \.self) { lang in
                                        Button(action: {
                                            selectedLanguage = lang
                                        }) {
                                            Text(LanguageHelper.getLocalizedLanguageName(lang).capitalized)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text(LanguageHelper.getLocalizedLanguageName(selectedLanguage).capitalized)
                                            .font(.system(size: 34, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Text("Learning")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            // ✅ BOTÓN + AQUÍ
                            Button {
                                newType = 1
                                showNewPhrase = true
                            } label: {
                                if #available(iOS 26.0, *) {
                                    Image(systemName: "plus.circle.fill")
                                    //.foregroundStyle(.accent)
                                        .font(.largeTitle)
                                        .glassEffect(.regular.interactive())
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.accent)
                                        .font(.largeTitle)
                                }
                            }
                        }
                        
                        // Stats Card con Glass Effect
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 6) {
                                Text("\(testPhrases.count)")
                                    .font(.system(size: 42, weight: .bold))  // ✅ Era 36
                                    .foregroundStyle(LinearGradient(
                                        colors: [
                                            Color(red: 0.08, green: 0.72, blue: 0.65),
                                            Color(red: 0.1, green: 0.7, blue: 0.8)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    ))
                                
                                Text("TO REVIEW")  // ✅ Uppercase
                                    .font(.caption2)  // ✅ Más pequeño
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)  // ✅ Era .medium
                                    .tracking(0.8)  // ✅ Letter spacing
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                            Divider()
                                .frame(height: 60)
                            
                            VStack(spacing: 6) {
                                Text("\(allPhrases.filter { $0.isCompleted && $0.language == selectedLanguage }.count)")
                                    .font(.system(size: 42, weight: .bold))  // ✅ Era 36
                                    .foregroundStyle(LinearGradient(
                                        colors: [
                                            Color(red: 0.08, green: 0.72, blue: 0.65),
                                            Color(red: 0.1, green: 0.7, blue: 0.8)
                                        ],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    ))
                                
                                Text("LEARNED")  // ✅ Uppercase
                                    .font(.caption2)  // ✅ Más pequeño
                                    .foregroundColor(.secondary)
                                    .fontWeight(.semibold)  // ✅ Era .medium
                                    .tracking(0.8)  // ✅ Letter spacing
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                        }
                        .padding(.vertical, 20)  // ✅ Más padding vertical
                        .padding(.horizontal, 20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    // Section Header para la lista
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All Words to Review")
                            .font(.system(size: 18, weight: .bold))  // ✅ Era 20, ahora 18
                            .foregroundColor(.primary)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)  // ✅ Era 16
                            .padding(.bottom, 4)  // ✅ Agregar
                        
                        // Lista de palabras
                        if testPhrases.isEmpty {
                            VStack(alignment: .center, spacing: 10) {
                                Spacer()
                                Image(systemName: "tray")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                
                                Text("No expressions to review!")
                                    .fontWeight(.semibold)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Text("Save the words and phrases you discover and build your vocabulary from the things you live, see, and hear every day.")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        } else {
                            ScrollView {
                                VStack(spacing: 10) {  // ✅ Era 12, ahora 10
                                    ForEach(testPhrases, id: \.self) { phrase in
                                        WordElementView(phrase: phrase, isCollection: false)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 20)  // ✅ Agregar padding inferior
                            }
                        }
                    }
                    
                    
                    
                }
                .sheet(isPresented: $showNewPhrase) {
                    NewPhraseView(newPhraseText: $newPhraseText,
                                  showNewPhrase: $showNewPhrase,
                                  phrases: $phrases,
                                  newType: $newType)
                    .presentationDetents([.fraction(0.40)])
                    .presentationCornerRadius(28)
                }
                .onTapGesture {
                    hideKeyboard()
                }
                
                Spacer()
                
            }.onAppear {
                
                guard !hasInsertedDefaultCategories else { return }
                
                let fetchRequest = FetchDescriptor<Category>()
                do {
                    let existingCategories = try modelContext.fetch(fetchRequest)
                    let existingCategoryNames = Set(existingCategories.map { $0.name }) // Collect existing category names
                    
                    // Filter categories to insert, excluding those already present
                    let categoriesToInsert = categories.filter { !existingCategoryNames.contains($0.name) }
                    
                    for category in categoriesToInsert {
                        modelContext.insert(category)
                    }
                    
                    // Save the context if there are new categories
                    if !categoriesToInsert.isEmpty {
                        try modelContext.save()
                    }
                    
                    hasInsertedDefaultCategories = true // ✅ Dopo aver salvat
                } catch {
                    print("Error fetching or saving categories: \(error)")
                }
                
                
                
                
            }
            .onAppear {
                // Check if both userName and selectedLanguage are set
                if userName == "No name set" || selectedLanguage == "No language selected" {
                    isPresenting = true // Show the welcome screen
                } else {
                    isPresenting = false // Skip the welcome screen if both are set
                }
            }
            .onAppear {
                if !hasMigratedLanguages {
                    let fetchDescriptor = FetchDescriptor<LearnElement>()
                    do {
                        let phrases = try modelContext.fetch(fetchDescriptor)
                        for phrase in phrases {
                            if phrase.language == nil {
                                phrase.language = selectedLanguage
                            }
                        }
                        try modelContext.save()
                        hasMigratedLanguages = true
                        print("✅ Migration completed")
                    } catch {
                        print("❌ Migration error: \(error)")
                    }
                }
            }
            .onAppear {
                if languageStore.userLanguages.isEmpty {
                    if selectedLanguage != "" {
                        languageStore.addLanguage(selectedLanguage)
                    }
                }
            }
            .fullScreenCover(isPresented: $hasSeenOnboarding, onDismiss: didDismiss) {
                OnboardingView()
            }
            .sheet(isPresented: $isPresentingInfo) {
                AboutView()
            }
            .sheet(isPresented: $isPresentingSettings) {
                SectionSettingsView()
            }
            
        }
    }
    
    func didDismiss() {
        dismiss()
    }
    
    
}

#Preview {
    ContentView()
}

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
            // espacio para la rayita
            .padding(.leading, 16 + 4) // 16 = inset, 4 = ancho de la raya
            // card
            .background(.ultraThinMaterial, in: shape)
            // raya DENTRO de la card
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
                    .frame(width: 4, height: 28)   // ← pequeña dentro
                    .padding(.leading, 16)         // ← inset interno
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




struct NewPhraseView: View {
    @Binding var newPhraseText: String
    @Binding var showNewPhrase: Bool
    @Binding var phrases: [String]
    @Binding var newType: Int

    @Environment(\.modelContext) var modelContext
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"

    @FocusState private var isFocused: Bool
    let maxCharacters = 50

    private var trimmed: String { newPhraseText.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var remaining: Int { max(0, maxCharacters - newPhraseText.count) }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Title + mini progress
            HStack(spacing: 10) {
                Text(newType == 1 ? "Add New Expression" : "How to say…?")
                    .font(.title2).fontWeight(.semibold)
                ProgressRing(progress: Double(newPhraseText.count)/Double(maxCharacters))
            }

            Text(newType == 1
                 ? "Found a word or phrase you don’t understand? Save it to review later."
                 : "Write what you want to say in the language you’re learning.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(nil)                      // or .lineLimit(2/3)
                  .fixedSize(horizontal: false, vertical: true)
                  .multilineTextAlignment(.leading)
                  .frame(maxWidth: .infinity, alignment: .leading)
            // COMPACT TEXTFIELD
            HStack(spacing: 10) {
                Image(systemName: "text.magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Type the word or phrase…", text: $newPhraseText)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit { add() }
                    .onChange(of: newPhraseText) { old, new in
                        if new.count > maxCharacters { newPhraseText = String(new.prefix(maxCharacters)) }
                    }

                // clear button
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

            // helper row: counter
            HStack {
                Spacer()
                Text("\(remaining)")
                    .font(.caption).monospacedDigit()
                    .foregroundStyle(remaining == 0 ? .red : .secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        // bottom primary button (fixed, safe with home indicator)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(action: add) {
                    HStack(spacing: 10) {
                        Text("Add")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "plus")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
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
                Button("Cancel") { showNewPhrase = false }
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

// tiny progress ring (same as antes)
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



struct SectionSettingsView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Italian 🇮🇹"
    @Environment(\.dismiss) var dismiss
    
    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇵🇹", "Spanish 🇪🇸", "Turkish 🇹🇷"]
    
    @EnvironmentObject var languageStore: LanguageStore
    @State private var showAddLanguage = false
    @State private var languageToDelete: String?
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nickname")) {
                    TextField("Enter your nickname", text: $userName)
                }
  
                
                Section(header: Text("Languages you are learning")) {
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
                        // Reset selected language if needed
                        if selectedLanguage == languageToDelete {
                            selectedLanguage = languageStore.userLanguages.first ?? ""
                        }
                        
                        
                    }
                }
                
                Button {
                    showAddLanguage = true
                } label: {
                    Text("Add Language")
                }
                
                
                
                
                
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
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



extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

