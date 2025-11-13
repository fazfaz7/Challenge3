//
//  OnboardingView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 19/04/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true
    @State private var currentPage = 0
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground(progress: progress)
            
            // Content
            TabView(selection: $currentPage) {
                OnboardingPage1()
                    .tag(0)
                
                OnboardingPage2()
                    .tag(1)
                
                OnboardingPage3()
                    .tag(2)
                
                OnboardingPage4()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onChange(of: currentPage) { oldValue, newValue in
                withAnimation(.easeInOut(duration: 0.5)) {
                    progress = CGFloat(newValue) / 3.0
                }
            }
            
            // Top controls
            VStack {
                HStack {
                    Spacer()
                    
                    if currentPage < 3 {
                        Button {
                            withAnimation {
                                currentPage = 3
                            }
                        } label: {
                            Text("Skip")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(.white.opacity(0.2))
                                )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
                
                Spacer()
            }
            
            // Bottom progress indicator
            VStack {
                Spacer()
                
                if currentPage < 3 {
                    HStack(spacing: 12) {
                        ForEach(0..<3) { index in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: currentPage == index ? 32 : 24, height: 6)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    let progress: CGFloat
    
    var body: some View {
        // Always use the brand teal gradient - no color changes
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.72, blue: 0.65),
                Color(red: 0.1, green: 0.7, blue: 0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Page 1: Main Value
struct OnboardingPage1: View {
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                // Emoji with parallax effect
                Text("📚")
                    .font(.system(size: 100))
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                
                VStack(spacing: 16) {
                    Text("Learn Through")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                    
                    Text("Real Life")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                }
                
                Text("Capture words and phrases as you\nencounter them in your daily life")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 40)
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                appeared = true
            }
        }
    }
}

// MARK: - Page 2: Features
struct OnboardingPage2: View {
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                Text("✨")
                    .font(.system(size: 100))
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                
                VStack(spacing: 16) {
                    Text("Save & Learn")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                    
                    Text("Your Personal Vocabulary")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                }
                
                VStack(spacing: 20) {
                    FeatureCard(
                        icon: "💭",
                        title: "Save instantly",
                        description: "Don't know a word? Save it for later",
                        appeared: appeared,
                        delay: 0.1
                    )
                    
                    FeatureCard(
                        icon: "📝",
                        title: "Add meanings",
                        description: "Complete entries when you're ready",
                        appeared: appeared,
                        delay: 0.2
                    )
                    
                    FeatureCard(
                        icon: "🗂️",
                        title: "Stay organized",
                        description: "Use categories to group your words",
                        appeared: appeared,
                        delay: 0.3
                    )
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                appeared = true
            }
        }
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let appeared: Bool
    let delay: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Text(icon)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.15))
                .blur(radius: 0.5)
        )
        .offset(x: appeared ? 0 : -50)
        .opacity(appeared ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(delay), value: appeared)
    }
}

// MARK: - Page 3: Widget
struct OnboardingPage3: View {
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                Text("🧠")
                    .font(.system(size: 100))
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                
                VStack(spacing: 16) {
                    Text("Practice Daily")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                    
                    Text("Add the home screen widget to\nreview words throughout the day")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 40)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                }
                
                // Widget preview mockup
                VStack(spacing: 12) {
                    HStack {
                        Text("🇮🇹")
                            .font(.title2)
                        Spacer()
                    }
                    
                    Text("Ciao")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 1)
                        .frame(maxWidth: 60)
                        .frame(maxWidth: .infinity)
                    
                    Text("Hello")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(24)
                .frame(width: 280)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white.opacity(0.2))
                        .blur(radius: 0.5)
                )
                .scaleEffect(appeared ? 1 : 0.8)
                .opacity(appeared ? 1 : 0)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                appeared = true
            }
        }
    }
}

// MARK: - Page 4: Welcome Setup
struct OnboardingPage4: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("selectedLanguage") var selectedLanguage: String = ""
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true
    @EnvironmentObject var languageStore: LanguageStore
    
    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇵🇹", "Spanish 🇪🇸", "Turkish 🇹🇷"]
    
    @State private var appeared = false
    @State private var showLanguageSheet = false
    @State private var tempSelectedLanguage: String = "Italian 🇮🇹"
    @FocusState private var isNameFieldFocused: Bool
    
    var isFormComplete: Bool {
        !userName.trimmingCharacters(in: .whitespaces).isEmpty && !tempSelectedLanguage.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer().frame(height: 60)
                
                // Header
                VStack(spacing: 16) {
                    Text("👋")
                        .font(.system(size: 80))
                        .scaleEffect(appeared ? 1 : 0.5)
                        .opacity(appeared ? 1 : 0)
                    
                    VStack(spacing: 8) {
                        Text("Welcome!")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                            .offset(y: appeared ? 0 : 20)
                            .opacity(appeared ? 1 : 0)
                        
                        Text("Let's personalize your experience")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.85))
                            .offset(y: appeared ? 0 : 20)
                            .opacity(appeared ? 1 : 0)
                    }
                }
                
                // Form
                VStack(spacing: 20) {
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What's your name?")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        TextField("", text: $userName, prompt: Text("Enter your name").foregroundStyle(.white.opacity(0.5)))
                            .foregroundStyle(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        isNameFieldFocused ? Color.white.opacity(0.5) : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .focused($isNameFieldFocused)
                    }
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: appeared)
                    
                    // Language selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Which language are you learning?")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Button {
                            showLanguageSheet = true
                        } label: {
                            HStack {
                                Text(LanguageHelper.flag(from: tempSelectedLanguage))
                                    .font(.title3)
                                
                                Text(LanguageHelper.getLocalizedLanguageName(tempSelectedLanguage))
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                            )
                        }
                    }
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: appeared)
                }
                .padding(.horizontal, 32)
                
                // Get Started button
                Button {
                    // Set the selected language ONLY when user completes onboarding
                    selectedLanguage = tempSelectedLanguage
                    languageStore.addLanguage(tempSelectedLanguage)
                    hasSeenOnboarding = false
                } label: {
                    HStack(spacing: 10) {
                        Text("Start Learning")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Group {
                            if isFormComplete {
                                // Solid white background (more contrast on gradient)
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                            }
                        }
                    )
                    .overlay(
                        Group {
                            if isFormComplete {
                                // Gradient text effect
                                HStack(spacing: 10) {
                                    Text("Start Learning")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.headline)
                                }
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.08, green: 0.72, blue: 0.65),
                                            Color(red: 0.1, green: 0.7, blue: 0.8)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            }
                        }
                    )
                    .shadow(
                        color: isFormComplete ? .black.opacity(0.1) : .clear,
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                }
                .disabled(!isFormComplete)
                .padding(.horizontal, 32)
                .padding(.top, 8)
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5), value: appeared)
                
                Spacer().frame(height: 60)
            }
        }
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSelectionSheet(selectedLanguage: $tempSelectedLanguage)
        }
        .onAppear {
            // Initialize temp language from saved value if exists, otherwise default to Italian
            if !selectedLanguage.isEmpty {
                tempSelectedLanguage = selectedLanguage
            }
            
            withAnimation {
                appeared = true
            }
        }
    }
}

// MARK: - Language Selection Sheet
struct LanguageSelectionSheet: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) var dismiss
    
    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇵🇹", "Spanish 🇪🇸", "Turkish 🇹🇷"]
    
    var body: some View {
        ZStack {
            // Gradient background matching onboarding
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.72, blue: 0.65),
                    Color(red: 0.1, green: 0.7, blue: 0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Select Language")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(languages, id: \.self) { language in
                            Button {
                                selectedLanguage = language
                                dismiss()
                            } label: {
                                HStack(spacing: 16) {
                                    Text(LanguageHelper.flag(from: language))
                                        .font(.system(size: 36))
                                    
                                    Text(LanguageHelper.getLocalizedLanguageName(language))
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    if language == selectedLanguage {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.white.opacity(language == selectedLanguage ? 0.3 : 0.15))
                                )
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
}

#Preview {
    OnboardingView()
        .environmentObject(LanguageStore.shared)
}
