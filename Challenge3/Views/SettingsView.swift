//
//  SettingsView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 11/11/25.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Italian 🇮🇹"
    @EnvironmentObject var languageStore: LanguageStore
    @EnvironmentObject private var streakStore: QuizStreakStore
    @Environment(\.modelContext) private var modelContext

    private var currentStreak: Int { streakStore.getStats(for: selectedLanguage).currentStreak }

    @State private var showAddLanguage = false
    @State private var showAboutSheet = false
    @State private var languageToDelete: String?
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient iOS 18
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // HEADER
                        VStack(alignment: .leading, spacing: 4) {
                            Text(LocalizedStringKey("Settings"))
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.primary)

                            Text(LocalizedStringKey("Customize your learning experience"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                        
                        // PROFILE SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey("PROFILE"))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .tracking(0.5)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 16) {
                                    // Avatar
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.08, green: 0.72, blue: 0.65),
                                                        Color(red: 0.1, green: 0.7, blue: 0.8)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 60, height: 60)
                                        
                                        Text(userName.isEmpty ? "?" : String(userName.prefix(1).uppercased()))
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Name field
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(LocalizedStringKey("Nickname"))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .fontWeight(.medium)

                                        TextField(LocalizedStringKey("Enter your name"), text: $userName)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(20)
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 24)
                        }
                        
                        // LANGUAGES SECTION
                        VStack(alignment: .leading, spacing: 4) {
                            Text(LocalizedStringKey("LANGUAGES YOU'RE LEARNING"))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .tracking(0.5)
                                .padding(.horizontal, 24)

                            Text("Tap to switch active language")
                                .font(.caption)
                                .foregroundColor(.secondary.opacity(0.7))
                                .padding(.horizontal, 24)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 0) {
                                ForEach(Array(languageStore.userLanguages.enumerated()), id: \.element) { index, language in
                                    Button {
                                        selectedLanguage = language
                                    } label: {
                                        HStack(spacing: 16) {
                                            // Flag
                                            Text(LanguageHelper.flag(from: language))
                                                .font(.system(size: 32))
                                            
                                            // Language name
                                            Text(LanguageHelper.getLocalizedLanguageName(language).capitalized)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            // Checkmark if selected
                                            if language == selectedLanguage {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.title3)
                                                    .foregroundColor(.accentColor)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(
                                            language == selectedLanguage
                                            ? Color.accentColor.opacity(0.08)
                                            : Color.clear
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        if languageStore.userLanguages.count > 1 {
                                            Button(role: .destructive) {
                                                languageToDelete = language
                                                showDeleteAlert = true
                                            } label: {
                                                Label("Delete Language", systemImage: "trash.fill")
                                            }
                                        }
                                    }
                                    
                                    if index < languageStore.userLanguages.count - 1 {
                                        Divider()
                                            .padding(.leading, 68)
                                    }
                                }
                                
                                // Add language button
                                Button {
                                    showAddLanguage = true
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.accentColor)
                                        
                                        Text(LocalizedStringKey("Add Language"))
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.accentColor)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                }
                                .buttonStyle(.plain)
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 24)
                        }
                        
                        // QUIZ SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text("DAILY CHALLENGE")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .tracking(0.5)
                                .padding(.horizontal, 24)

                            VStack(spacing: 0) {
                                HStack(spacing: 16) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 22))
                                        .foregroundStyle(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
                                        .frame(width: 32)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Current streak")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("\(currentStreak) \(currentStreak == 1 ? "day" : "days")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)

                            }
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 24)
                        }

                        // ABOUT SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text(LocalizedStringKey("ABOUT"))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .tracking(0.5)
                                .padding(.horizontal, 24)
                            
                            Button {
                                showAboutSheet = true
                            } label: {
                                HStack(spacing: 16) {
                                    // App icon
                                    Image("MyIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("ItMeans")
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        
                                        Text(LocalizedStringKey("Version 1.3"))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(20)
                            }
                            .buttonStyle(.plain)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                            .padding(.horizontal, 24)
                        }
                        
                        // Footer
                        Text(LocalizedStringKey("© 2025 ItMeans"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddLanguage) {
                AddLanguageView()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showAboutSheet) {
                AboutSheetView()
                    .presentationDetents([.large])
            }
            .alert(LocalizedStringKey("Delete Language"), isPresented: $showDeleteAlert) {
                Button(LocalizedStringKey("Delete"), role: .destructive) {
                    if let languageToDelete = languageToDelete {
                        languageStore.removeLanguage(languageToDelete)
                        if selectedLanguage == languageToDelete {
                            selectedLanguage = languageStore.userLanguages.first ?? ""
                        }
                    }
                }
                Button(LocalizedStringKey("Cancel"), role: .cancel) {
                    languageToDelete = nil
                }
            } message: {
                if let languageToDelete = languageToDelete {
                    Text("This will remove \(LanguageHelper.getLocalizedLanguageName(languageToDelete)) from your learning languages.")
                }
            }
        }
    }

}

// MARK: - About Sheet View
struct AboutSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                Color(.systemGroupedBackground)
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // App Icon + Title
                        VStack(spacing: 16) {
                            Image("MyIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                            
                            VStack(spacing: 4) {
                                Text("ItMeans")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text(LocalizedStringKey("Your personal vocabulary builder"))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // What is ItMeans?
                        VStack(alignment: .leading, spacing: 12) {
                            Label(LocalizedStringKey("What is ItMeans?"), systemImage: "questionmark.circle.fill")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)

                            Text(LocalizedStringKey("ItMeans is your personal space to save the words, phrases, and expressions you encounter while immersing yourself in a new language."))
                                .font(.body)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                        
                        // How it works
                        VStack(alignment: .leading, spacing: 12) {
                            Label(LocalizedStringKey("How it works"), systemImage: "lightbulb.fill")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)

                            VStack(alignment: .leading, spacing: 12) {
                                FeatureRow(icon: "✍️", text: NSLocalizedString("Save any new words, phrases, or slang you discover.", comment: ""))
                                FeatureRow(icon: "📚", text: NSLocalizedString("Review your collection as you learn.", comment: ""))
                                FeatureRow(icon: "🤝", text: NSLocalizedString("Complete your pendings by asking a native speaker or by searching.", comment: ""))
                                FeatureRow(icon: "🧠", text: NSLocalizedString("Activate the widget to practice your saved words daily.", comment: ""))
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                        
                        // Rate button
                        Button {
                            requestReview()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                Text("Rate ItMeans")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.08, green: 0.72, blue: 0.65),
                                        Color(red: 0.1, green: 0.7, blue: 0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color(red: 0.08, green: 0.72, blue: 0.65).opacity(0.3), radius: 10, x: 0, y: 4)
                        }

                        // Footer
                        VStack(spacing: 8) {
                            Text("Version 1.3")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("© 2025 ItMeans")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(LocalizedStringKey("Done")) {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title3)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/*
#Preview {
    SettingsView()
        .environmentObject(LanguageStore())
}
*/
