//
//  DetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 01/11/24.
//

import SwiftUI
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
                                
                                // Botón audio (solo si es newPhrase y el idioma tiene soporte TTS)
                                if phrase.learnType == .newPhrase && LanguageStore.supportsTextToSpeech(phrase.language ?? selectedLanguage) {
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








