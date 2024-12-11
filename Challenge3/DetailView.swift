//
//  DetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 01/11/24.
//

import SwiftUI
import AVKit

struct DetailView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var showCategoryView: Bool = false
    @State var categorySelected: Category?
    @State private var animationsRunning = false
    @State var selectedCategory: Category? = nil
    
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(phrase.learnType == .newPhrase ? "New phrase" : "How to say...?")
                        .foregroundStyle(.accent)
                        .fontWeight(.medium)
                    Text(phrase.userEntry)
                        .font(.title)
                        .fontWeight(.semibold)
                        .italic()
                    
                    
                    
                }
                
                Spacer()
                
                if phrase.learnType == .newPhrase {
                    ZStack {
                        Circle()
                            .frame(width: 55)
                            .padding(.horizontal)
                            .foregroundStyle(.accent)
                        
                        Button {
                            animationsRunning.toggle()
                           
                            /*let utterance = AVSpeechUtterance(string: phrase.userEntry)
                            utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")

                            let synthesizer = AVSpeechSynthesizer()
                            synthesizer.speak(utterance)
                            */
                        } label: {
                            Image(systemName: "speaker.3")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .symbolEffect(.variableColor.iterative, options: .repeating, value: animationsRunning)
                            
                        }
                        
                    }
                }
                
                
            }.padding(.bottom, 2)
            
            
            VStack(alignment: .leading, spacing: 20){
                Text("Adrian, write the explanation of the phrase or word here and finish your pending! Clear your doubt and save it!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextEditor(text: $phrase.explanation)
                    .frame(width:Global.screenWidth*0.78 ,height: 100) //
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 1))
                
                
                VStack(alignment:.leading) {
                    Text("Category")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.medium)
                    Button {
                        showCategoryView.toggle()
                    } label: {
                        
                        HStack {
                            if let selectedCategory = selectedCategory{
                                Text(selectedCategory.emoji)
                                    .font(.title3)
                                Text(selectedCategory.name)
                                    .foregroundStyle(.black)
                            } else {
                                Text("None")
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            
                            Image(systemName: "triangle.fill")
                                .foregroundStyle(.gray.opacity(0.4))
                                .rotationEffect(.degrees(180))
                        }.padding()
                            .frame(width: Global.screenWidth*0.85, height:50).background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.15)))
                    }
                }
                HStack {
                    Spacer()
                    Button {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            phrase.category = categorySelected
                            phrase.isCompleted = true
                            try? modelContext.save()
                        }
                        
                        dismiss()
                    } label: {
                        HStack {
                            Text("Complete pending")
                            Image(systemName: "checkmark")
                        }
                        .padding(15)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        .foregroundStyle(.white)
                    }
                    Spacer()
                }
                
            }
            
            
            
            Spacer()
            
        }            .frame(width: Global.screenWidth*0.85)
        
            .sheet(isPresented: $showCategoryView) {
                SelectCategoryView(selectedCategory: $selectedCategory)
                    .presentationDetents([.fraction(0.85)])
                
            }
    }
}


#Preview {
    DetailView(phrase: LearnElement(learnType: .newPhrase, userEntry: "In bocca al lupo", explanation: ""))
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
