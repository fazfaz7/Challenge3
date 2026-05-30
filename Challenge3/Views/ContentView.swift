//
//  ContentView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ContentView: View {
    @State var showNewPhrase: Bool = false
    @State var newPhraseText: String = ""
    @State var newType: Int = 1
    @Query(sort: \LearnElement.dateAdded, order: .reverse) var allPhrases: [LearnElement]
    
    var testPhrases: [LearnElement] {
        allPhrases.filter { !$0.isCompleted && $0.language == selectedLanguage }
    }
    
    @Environment(\.modelContext) var modelContext
    @AppStorage("userName") private var userName: String = "No name set"
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true
    @AppStorage("hasInsertedDefaultCategories") private var hasInsertedDefaultCategories: Bool = false
    @AppStorage("hasMigratedLanguages") private var hasMigratedLanguages = false
    @AppStorage("hasPortugueseFlagMigrated") private var hasPortugueseFlagMigrated = false
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
                                
                                Text(LocalizedStringKey("Learning"))
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
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundStyle(LinearGradient(
                                            colors: [
                                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                                Color(red: 0.1, green: 0.7, blue: 0.8)
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        ))
                                        .font(.largeTitle)
                                        .glassEffect(.regular.interactive())
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .symbolRenderingMode(.monochrome)
                                        .foregroundStyle(LinearGradient(
                                            colors: [
                                                Color(red: 0.08, green: 0.72, blue: 0.65),
                                                Color(red: 0.1, green: 0.7, blue: 0.8)
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        ))
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
                                
                                Text(LocalizedStringKey("TO REVIEW"))  // ✅ Uppercase
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
                                
                                Text(LocalizedStringKey("LEARNED"))  // ✅ Uppercase
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
                        Text(LocalizedStringKey("All Words to Review"))
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
                                
                                Text(LocalizedStringKey("No expressions to review!"))
                                    .fontWeight(.semibold)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)

                                Text(LocalizedStringKey("Save the words and phrases you discover and build your vocabulary from the things you live, see, and hear every day."))
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
                                  newType: $newType)
                    .presentationDetents([.height(300)])
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
                if !hasMigratedLanguages && !selectedLanguage.isEmpty {
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

                // Migrate Portuguese flag from 🇵🇹 to 🇧🇷
                if !hasPortugueseFlagMigrated {
                    let fetchDescriptor = FetchDescriptor<LearnElement>()
                    do {
                        let phrases = try modelContext.fetch(fetchDescriptor)
                        var migratedCount = 0
                        for phrase in phrases {
                            if phrase.language == "Portuguese 🇵🇹" {
                                phrase.language = "Portuguese 🇧🇷"
                                migratedCount += 1
                            }
                        }

                        // Also migrate in user's language store
                        if let index = languageStore.userLanguages.firstIndex(of: "Portuguese 🇵🇹") {
                            languageStore.userLanguages[index] = "Portuguese 🇧🇷"
                            languageStore.saveLanguages()
                        }

                        // Migrate selected language if needed
                        if selectedLanguage == "Portuguese 🇵🇹" {
                            selectedLanguage = "Portuguese 🇧🇷"
                        }

                        try modelContext.save()
                        hasPortugueseFlagMigrated = true

                        // Refresh widget to show migrated data
                        WidgetCenter.shared.reloadAllTimelines()

                        print("✅ Portuguese flag migration completed: \(migratedCount) words migrated")
                    } catch {
                        print("❌ Portuguese migration error: \(error)")
                    }
                }
            }
            .onAppear {
                // Only add language to store AFTER onboarding is complete
                if !hasSeenOnboarding && !selectedLanguage.isEmpty {
                    if languageStore.userLanguages.isEmpty {
                        languageStore.addLanguage(selectedLanguage)
                    }
                }
            }
            .fullScreenCover(isPresented: $hasSeenOnboarding, onDismiss: didDismiss) {
                OnboardingView()
            }
            .onAppear {
                // Safety: If user is past onboarding but has no language, use first from store
                if !hasSeenOnboarding && selectedLanguage.isEmpty && !languageStore.userLanguages.isEmpty {
                    selectedLanguage = languageStore.userLanguages.first ?? ""
                }
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




extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

