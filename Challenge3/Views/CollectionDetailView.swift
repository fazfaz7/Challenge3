//
//  CollectionDetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 02/11/24.
//

import SwiftUI
import SwiftData

struct CollectionDetailView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"
    @StateObject private var viewModel = TextToSpeechViewModel(textToSpeechService: TextToSpeechService())
    @State private var isEditing = false
    @State private var shareImage: UIImage?
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // Background gradient iOS 18
            Color(.systemGroupedBackground).ignoresSafeArea()
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // HEADER: Badge + Palabra
                    VStack(spacing: 16) {
                        // Badge "New Expression"
                        HStack {
                            Spacer()
                            Text("New Expression")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                                .tracking(0.5)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.08, green: 0.72, blue: 0.65),
                                                    Color(red: 0.1, green: 0.7, blue: 0.8)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                                .shadow(color: .accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                            Spacer()
                        }
                        
                        // Palabra principal
                        Text(phrase.userEntry)
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.7)
                            .lineLimit(3)
                            .padding(.horizontal, 24)
                        
                        // Botones Edit + Audio
                        HStack(spacing: 16) {
                            // Botón Edit
                            Button {
                                isEditing = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Edit")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.accentColor)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1.5)
                                )
                            }
                            
                            // Botón Audio
                            Button {
                                viewModel.speak(text: phrase.userEntry, language: selectedLanguage)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 48, height: 48)
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
                    .padding(.top, 20)
                    
                    // EXPLANATION CARD
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Explanation/Meaning")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.accentColor)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            Spacer()
                        }
                        
                        Text(phrase.explanation)
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
                    
                    // CATEGORY CARD (solo si existe)
                    if let category = phrase.category {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(LocalizedStringKey("Category"))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accentColor)
                                    .textCase(.uppercase)
                                    .tracking(0.5)
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                Text(category.emoji)
                                    .font(.system(size: 32))
                                
                                Text(category.name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    generateAndShareImage()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditPhraseView(phrase: phrase)
        }
        .sheet(isPresented: $showShareSheet) {
            if let shareImage = shareImage {
                ShareSheet(items: [shareImage])
            }
        }
    }

    // MARK: - Share Image Generation
    private func generateAndShareImage() {
        let languageFlag = phrase.language.map { LanguageHelper.flag(from: $0) } ?? "🌍"

        let shareView = ShareImageView(
            phrase: phrase.userEntry,
            meaning: phrase.explanation,
            languageFlag: languageFlag
        )

        let renderer = ImageRenderer(content: shareView)
        renderer.scale = 3.0 // High quality for retina displays

        if let uiImage = renderer.uiImage {
            shareImage = uiImage
            showShareSheet = true
        }
    }
}

#Preview {
    CollectionDetailView(phrase: LearnElement(learnType: .newPhrase, userEntry: "Amicizia", explanation: "Friendship", language: "Italian 🇮🇹"))
}

// MARK: - Share Sheet (UIActivityViewController Wrapper)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Edit Phrase View (Modernizado)
struct EditPhraseView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Category.dateAdded) var categories: [Category]
    
    @State private var editedEntry: String = ""
    @State private var editedExplanation: String = ""
    @State private var selectedCategory: Category?
    @State private var showCategorySheet = false
    @FocusState private var focusedField: Field?

    enum Field {
        case entry, explanation
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient iOS 18
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Expression field
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey("Expression"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            TextField(LocalizedStringKey("Enter phrase"), text: $editedEntry)
                                .font(.body)
                                .padding(16)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            focusedField == .entry ? Color.accentColor : Color.secondary.opacity(0.2),
                                            lineWidth: focusedField == .entry ? 2 : 1
                                        )
                                )
                                .focused($focusedField, equals: .entry)
                        }
                        
                        // Explanation field
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey("Explanation"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            TextField(LocalizedStringKey("Enter explanation"), text: $editedExplanation)
                                .font(.body)
                                .padding(16)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            focusedField == .explanation ? Color.accentColor : Color.secondary.opacity(0.2),
                                            lineWidth: focusedField == .explanation ? 2 : 1
                                        )
                                )
                                .focused($focusedField, equals: .explanation)
                        }
                        
                        // Category picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey("Category"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            Button {
                                showCategorySheet = true
                            } label: {
                                HStack(spacing: 12) {
                                    if let selectedCategory = selectedCategory {
                                        Text(selectedCategory.emoji)
                                            .font(.title3)
                                        Text(selectedCategory.name)
                                            .foregroundColor(.primary)
                                            .fontWeight(.medium)
                                    } else {
                                        Text(LocalizedStringKey("Select a category"))
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
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(LocalizedStringKey("Edit Phrase"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedStringKey("Save")) {
                        phrase.userEntry = editedEntry
                        phrase.explanation = editedExplanation
                        phrase.category = selectedCategory
                        do {
                            try modelContext.save()
                        } catch {
                            print("Error saving changes: \(error)")
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedStringKey("Cancel")) {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .sheet(isPresented: $showCategorySheet) {
                SelectCategoryView(selectedCategory: $selectedCategory)
            }
            .onAppear {
                editedEntry = phrase.userEntry
                editedExplanation = phrase.explanation
                selectedCategory = phrase.category
            }
        }
    }
}
