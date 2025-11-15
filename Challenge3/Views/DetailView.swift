//
//  DetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 01/11/24.
//

import SwiftUI
import AVKit
import Translation
import WidgetKit

struct DetailView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var showCategoryView: Bool = false
    @State private var animationsRunning = false
    @State var selectedCategory: Category? = nil
    @StateObject private var viewModel = TextToSpeechViewModel(textToSpeechService: TextToSpeechService())
    @State var showTranslation = false
    @AppStorage("userName") private var userName: String = "No name set"
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"
    @State var temporaryPhrase: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            
            Color(.systemGroupedBackground).ignoresSafeArea()
            .ignoresSafeArea()
            
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // HEADER: Label + Palabra + Botones
                    VStack(alignment: .leading, spacing: 12) {
                        // Label superior con uppercase
                        Text(phrase.learnType == .newPhrase ? "NEW EXPRESSION" : "HOW TO SAY...?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                            .tracking(0.8)
                        
                        // Palabra + botones
                        HStack(alignment: .top, spacing: 16) {
                            Text(phrase.userEntry)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.primary)
                                .italic()
                                .lineLimit(3)
                                .minimumScaleFactor(0.7)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            // Botones circulares con gradiente
                            HStack(spacing: 12) {
                                // Botón traducir
                                Button {
                                    showTranslation = true
                                } label: {
                                    Image(systemName: "translate")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.08, green: 0.72, blue: 0.65),
                                                    Color(red: 0.1, green: 0.7, blue: 0.8)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .clipShape(Circle())
                                        .shadow(color: .accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                                }
                                
                                // Botón audio (solo si es newPhrase)
                                if phrase.learnType == .newPhrase {
                                    Button {
                                        viewModel.speak(text: phrase.userEntry, language: selectedLanguage)
                                    } label: {
                                        Image(systemName: "speaker.wave.2.fill")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.08, green: 0.72, blue: 0.65),
                                                        Color(red: 0.1, green: 0.7, blue: 0.8)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .clipShape(Circle())
                                            .shadow(color: .accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                                    }
                                }
                            }
                        }
                    }
                    
                    // EXPLICACIÓN
                    VStack(alignment: .leading, spacing: 16) {
                        Text(String(format: NSLocalizedString(phrase.learnType == .newPhrase ? "pending_message" : "other_message", comment: ""), userName))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // TextField multilínea con glass effect
                        ZStack(alignment: .topLeading) {
                            // Placeholder
                            if phrase.explanation.isEmpty {
                                Text("Write your explanation here...")
                                    .foregroundColor(.secondary.opacity(0.5))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                            }
                            
                            // TextEditor con glass effect
                            TextEditor(text: $phrase.explanation)
                                .font(.body)
                                .foregroundColor(.primary)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 120)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .focused($isTextFieldFocused)
                                
                            
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    isTextFieldFocused ? Color.accentColor : Color.accentColor.opacity(0.3),
                                    lineWidth: isTextFieldFocused ? 2 : 1.5
                                )
                        )
                        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                    }
                    
                    // CATEGORY SELECTOR
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Button {
                            showCategoryView.toggle()
                        } label: {
                            HStack(spacing: 12) {
                                if let selectedCategory = selectedCategory {
                                    Text(selectedCategory.emoji)
                                        .font(.title3)
                                    Text(selectedCategory.name)
                                        .foregroundColor(.primary)
                                        .fontWeight(.medium)
                                } else {
                                    Text("None")
                                        .foregroundColor(.secondary)
                                        .fontWeight(.medium)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    // BOTÓN MARK COMPLETE
                    Button {
                        if phrase.learnType == .howToSay {
                            temporaryPhrase = phrase.explanation
                            phrase.explanation = phrase.userEntry
                            phrase.userEntry = temporaryPhrase
                        }
                        phrase.category = selectedCategory
                        phrase.isCompleted = true
                        try? modelContext.save()
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    } label: {
                        HStack(spacing: 10) {
                            Text("Mark complete")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Group {
                                if phrase.explanation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
                            color: phrase.explanation.isEmpty ? .clear : .accentColor.opacity(0.3),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                    }
                    .disabled(phrase.explanation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.top, 16)
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCategoryView) {
            SelectCategoryView(selectedCategory: $selectedCategory)
                .presentationDetents([.fraction(0.85)])
        }
        .translationPresentation(isPresented: $showTranslation, text: phrase.userEntry) { translatedText in
            phrase.explanation = translatedText
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}


#Preview {
    DetailView(phrase: LearnElement(learnType: .newPhrase, userEntry: "Famm nu tagl che m ", explanation: "", language: "Italian 🇮🇹"))
}


struct ChooseCategoryView: View {
    @Binding var categorySelected: Category
    
    var body: some View {
        ZStack {
            VStack {
                Text("Choose the category that best represents your new phrase/word")
                
                Picker("", selection: $categorySelected) {
                    ForEach(categories, id: \.self) { category in
                        Text("\(category.name) \(category.emoji)")
                    }
                }
                .pickerStyle(.wheel)
                
            }.padding()
        }
    }
}


import AVFoundation

class TextToSpeechService {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0

        if language.contains("Italian") {
            utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        } else if language.contains("Spanish") {
            utterance.voice = AVSpeechSynthesisVoice(language: "es-MX") // or "es-ES" for Spain
        } else if language.contains("French") {
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        } else if language.contains("German") {
            utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        } else if language.contains("Chinese") {
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN") // Mandarin (China)
        } else if language.contains("Japanese") {
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        } else if language.contains("Portuguese") {
            utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR") // Portugal, or "pt-BR" for Brazil
        } else if language.contains("Turkish") {
            utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        } else if language.contains("English") {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB") // British English
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Default fallback
        }

        synthesizer.speak(utterance)
    }
}


class TextToSpeechViewModel: ObservableObject {
    private let textToSpeechService: TextToSpeechService

    init(textToSpeechService: TextToSpeechService) {
        self.textToSpeechService = textToSpeechService
    }

    func speak(text: String, language: String) {
        textToSpeechService.speak(text: text, language: language)
    }
}





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
                // Background gradient iOS 18
                Color(.systemGroupedBackground)
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header description
                    Text(LocalizedStringKey("Select a language you want to learn"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                    
                    // Languages list
                    if availableLanguages.isEmpty {
                        // Empty state
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
                                            // Flag
                                            Text(LanguageHelper.flag(from: language))
                                                .font(.system(size: 36))
                                            
                                            // Language name
                                            Text(LanguageHelper.getLocalizedLanguageName(language).capitalized)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            // Arrow
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



