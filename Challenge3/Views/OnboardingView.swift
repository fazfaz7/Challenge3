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
                OnboardingPage0()
                    .tag(0)

                OnboardingPage1()
                    .tag(1)

                OnboardingPage2()
                    .tag(2)

                OnboardingPage3()
                    .tag(3)

                OnboardingPage4()
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onChange(of: currentPage) { oldValue, newValue in
                withAnimation(.easeInOut(duration: 0.5)) {
                    progress = CGFloat(newValue) / 4.0
                }
            }
            
            // Top controls
            VStack {
                HStack {
                    Spacer()

                    if currentPage < 4 {
                        Button {
                            withAnimation {
                                currentPage = 4
                            }
                        } label: {
                            Text(LocalizedStringKey("Skip"))
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

                if currentPage < 4 {
                    HStack(spacing: 12) {
                        ForEach(0..<4) { index in
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

// MARK: - Page 0: Welcome Screen
struct OnboardingPage0: View {
    @State private var appeared = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoRotation: Double = -10

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 40) {
                // App Icon/Logo with animations
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(appeared ? 1.2 : 0.8)
                        .opacity(appeared ? 1 : 0)

                    // App icon
                    Image("MyIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        .scaleEffect(logoScale)
                        .rotationEffect(.degrees(logoRotation))
                }

                VStack(spacing: 16) {
                    // Welcome text
                    Text(LocalizedStringKey("Welcome to"))
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .offset(y: appeared ? 0 : 30)
                        .opacity(appeared ? 1 : 0)

                    // App name
                    Text("ItMeans")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 30)
                        .opacity(appeared ? 1 : 0)
                }

                // Tagline
                Text(LocalizedStringKey("Your personal vocabulary builder"))
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 50)
                    .offset(y: appeared ? 0 : 30)
                    .opacity(appeared ? 1 : 0)

                // Swipe indicator
                VStack(spacing: 12) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))

                    Text(LocalizedStringKey("Swipe to continue"))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .offset(y: appeared ? 0 : 30)
                .opacity(appeared ? 0.8 : 0)
            }

            Spacer()
            Spacer()
        }
        .onAppear {
            // Logo entrance animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1)) {
                logoScale = 1.0
                logoRotation = 0
            }

            // Content fade in
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                appeared = true
            }

            // Continuous subtle pulse for glow
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1)) {
                logoScale = 1.05
            }
        }
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
                    Text(LocalizedStringKey("Learn Through"))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)

                    Text(LocalizedStringKey("Real Life"))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                }

                Text(LocalizedStringKey("Capture words and phrases as you\nencounter them in your daily life"))
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
                    Text(LocalizedStringKey("Save & Learn"))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                    
                    Text(LocalizedStringKey("Your Personal Vocabulary"))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                }
                
                VStack(spacing: 20) {
                    FeatureCard(
                        icon: "💭",
                        title: NSLocalizedString("Save instantly", comment: ""),
                        description: NSLocalizedString("Don't know a word? Save it for later", comment: ""),
                        appeared: appeared,
                        delay: 0.1
                    )

                    FeatureCard(
                        icon: "📝",
                        title: NSLocalizedString("Add meanings", comment: ""),
                        description: NSLocalizedString("Complete entries when you're ready", comment: ""),
                        appeared: appeared,
                        delay: 0.2
                    )

                    FeatureCard(
                        icon: "🗂️",
                        title: NSLocalizedString("Stay organized", comment: ""),
                        description: NSLocalizedString("Use categories to group your words", comment: ""),
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
                    Text(LocalizedStringKey("Practice Daily"))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: appeared ? 0 : 20)
                        .opacity(appeared ? 1 : 0)
                    
                    Text(LocalizedStringKey("Add the home screen widget to\nreview words throughout the day"))
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
    
    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇧🇷", "Spanish 🇪🇸", "Turkish 🇹🇷"]

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
                        Text(LocalizedStringKey("Welcome!"))
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                            .offset(y: appeared ? 0 : 20)
                            .opacity(appeared ? 1 : 0)
                        
                        Text(LocalizedStringKey("Let's personalize your experience"))
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
                        Text(LocalizedStringKey("What's your name?"))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        TextField("", text: $userName, prompt: Text(LocalizedStringKey("Enter your name")).foregroundStyle(.white.opacity(0.5)))
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
                        Text(LocalizedStringKey("Which language are you learning?"))
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
                        Text(LocalizedStringKey("Start Learning"))
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
                                    Text(LocalizedStringKey("Start Learning"))
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

    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇧🇷", "Spanish 🇪🇸", "Turkish 🇹🇷"]

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
                    Text(LocalizedStringKey("Select Language"))
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
