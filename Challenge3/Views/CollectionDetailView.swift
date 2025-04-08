//
//  CollectionDetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 02/11/24.
//

import SwiftUI

struct CollectionDetailView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"
    @StateObject private var viewModel = TextToSpeechViewModel(textToSpeechService: TextToSpeechService())
    

    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
                    VStack(alignment: .center) {

                        VStack(spacing: 20) {
                            VStack {
                                
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.callout)
                                    Spacer()
                                    Button {
                                        viewModel.speak(text: phrase.userEntry, language: selectedLanguage)
                                    } label: {
                                        Image(systemName: "speaker.wave.3.fill")
                                            .font(.callout)
                                        
                                    }
                                }
                                
                                HStack {
                                    
                                    Spacer()
                                    Text("New Phrase")
                                        .padding(.horizontal,10)
                                        .padding(.vertical,5)
                                        .background(RoundedRectangle(cornerRadius: 20).fill(.accent))
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    
                                    
                                }
                                
                                Text(phrase.userEntry)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.8)
                           
                            Divider()
                                .padding(.horizontal,20)
                            }
                            VStack {
                                Text("Explanation/Meaning")
                                    .foregroundStyle(.accent)
                                    .padding(.bottom,3)
                                    .fontWeight(.medium)
                                Text(phrase.explanation)
                                    .multilineTextAlignment(.center)
                                    
                                
                            }.font(.title3)
                            
                            if let category = phrase.category {
                            Divider()
                                .padding(.horizontal,20)
                            
                                VStack {
                                    Text("Category")
                                        .foregroundStyle(.accent)
                                        .padding(.bottom,3)
                                        .fontWeight(.medium)
                                    
                                    HStack {
                                        
                                        
                                        Text(category.emoji)
                                        Text(category.name)
                                        
                                    }
                                }.font(.title3)
                                
                            }
                        }
                        .padding(20)
                        .padding(.vertical,5)
                        .frame(width: Global.screenWidth*0.80)
                        .background(RoundedRectangle(cornerRadius: 20).fill(colorScheme == .dark ? Color.secondary.opacity(0.1)  : .white).shadow(radius: 0.5))
                        .frame(maxHeight: Global.screenHeight*0.50)
                        
                        
                        
                        
                    }
                    
                    
                    
                    

        }
        
    }
}

#Preview {
    CollectionDetailView(phrase: LearnElement(learnType: .newPhrase ,userEntry: "Ancora non so cosa sto facendo qua. ma ti voglio aiutare semopre", explanation: "Pero, locura! Nosotros nunca sabemos que está sucediendo por aca lol"))
}
