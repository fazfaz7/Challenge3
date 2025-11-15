//
//  WelcomeView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/01/25.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Italian 🇮🇹"
    let languages = ["Chinese 🇨🇳", "English 🇬🇧", "French 🇫🇷", "German 🇩🇪", "Italian 🇮🇹", "Japanese 🇯🇵", "Portuguese 🇧🇷", "Spanish 🇪🇸", "Turkish 🇹🇷"]
    @State var showAll: Bool = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    var isFormComplete: Bool {
        !userName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = true

    var body: some View {
        VStack(spacing: 30) {
            VStack {
            Image("MyIcon")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 100)
                .padding(.top)
            
                HStack {

                    Text(LocalizedStringKey("Welcome to \n ItMeans!"))
                        .font(.title)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.85)
                    
                }
                

            }
            
            if showAll {
                VStack {
                    HStack {
                        Text(LocalizedStringKey("What is your nickname?"))
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                        Spacer()
                    }.frame(width: Global.screenWidth*0.70)

                    TextField("", text: $userName, prompt: Text(LocalizedStringKey("Enter your nickname")).foregroundStyle(.gray))
                        .foregroundStyle(.black)
                        .padding(5)
                        .frame(width: Global.screenWidth*0.70)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        
                    
                }
                
                VStack {
                    HStack {
                        Text(LocalizedStringKey("Which language are you learning?"))
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                            .minimumScaleFactor(0.85)
                        Spacer()
                    }.frame(width: Global.screenWidth*0.70)
                    
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(LocalizedStringKey(language))
                                .font(.title3)
                                .foregroundStyle(.black)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: Global.screenWidth*0.70, height: Global.screenHeight*0.10)
                    
                    Button {
                        hasSeenOnboarding = false
                    } label: {
                        HStack {
                            Text(LocalizedStringKey("Get Started!"))
                                .foregroundStyle(.white)
                        }.padding(12)
                            .font(.title3)
                            .frame(width: Global.screenWidth*0.70, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(isFormComplete ? Color.accentColor : Color.gray))
                            .shadow(radius: 1)
                            .padding(.vertical)
                    }.disabled(!isFormComplete)
                }
                
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                withAnimation(.easeIn(duration: 0.8)) {
                    showAll = true
                }
            }
        }
        .frame(width: Global.screenWidth*0.75, height: Global.screenHeight*0.60)
    }
}

#Preview {
    WelcomeView()
}
