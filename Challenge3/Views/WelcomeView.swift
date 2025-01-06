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
    let languages = ["Italian 🇮🇹", "Spanish 🇪🇸", "German 🇩🇪", "French 🇫🇷"]
    @State var showAll: Bool = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some View {
        VStack(spacing: 30) {
            Image("LyngoIcon")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 150)
            VStack {
                HStack {

                    Text("Lyngo")
                        .font(.title)
                        .fontWeight(.bold)
                    
                }
                
                Text("Never stop learning!")
                    .italic()
            }
            
            if showAll {
                VStack {
                    HStack {
                        Text("What is your nickname?")
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                        Spacer()
                    }.frame(width: Global.screenWidth*0.85)
                    
                    TextField("Enter your nickname", text: $userName)
                        .foregroundStyle(.black)
                        .frame(width: Global.screenWidth*0.85)
                        .textFieldStyle(.roundedBorder)
                    
                    
                }
                
                VStack {
                    HStack {
                        Text("Which language are you learning?")
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                        Spacer()
                    }.frame(width: Global.screenWidth*0.85)
                    
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) {
                            Text($0)
                                .font(.title3)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: Global.screenWidth*0.85, height: Global.screenHeight*0.10)
                    
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Everything's ready!")
                                .foregroundStyle(.white)
                        }.padding(12)
                            .font(.title3)
                            .frame(width: Global.screenWidth*0.85, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.accent))
                            .shadow(radius: 1)
                            .padding(.vertical)
                    }
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                withAnimation(.easeIn(duration: 0.8)) {
                    showAll = true
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
