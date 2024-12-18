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
    @State var categorySelected: Category?
    @State private var animationsRunning = false
    @State var selectedCategory: Category? = nil
    @StateObject private var viewModel = TextToSpeechViewModel(textToSpeechService: TextToSpeechService())
    @State var showTranslation = false
    
    var body: some View {
        ScrollView {
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
                    }                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    
                    if phrase.learnType == .newPhrase {
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(width: 48)
                                    .foregroundStyle(.accent)
                                
                                Button {
                            
                                    showTranslation = true
                                } label: {
                                    Image(systemName: "translate")
                                        .foregroundStyle(.white)

                                    
                                }
                                
                            }                    .fixedSize(horizontal: false, vertical: true)
                            
                            ZStack {
                                Circle()
                                    .frame(width: 48)
                                    
                                    .foregroundStyle(.accent)
                                
                                Button {
                                    animationsRunning.toggle()
                                    viewModel.speak()
                                    
                                } label: {
                                    Image(systemName: "speaker.3")
                                        .foregroundStyle(.white)
                                        .symbolEffect(.variableColor.iterative, options: .repeating, value: animationsRunning)
                                    
                                }
                                
                            }                    .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                }.padding(.bottom, 2)
                
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Adrian, write the explanation of the phrase or word here and finish your pending! Clear your doubt and save it!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                
                    
                    TextEditor(text: $phrase.explanation)
                        .frame(width:Global.screenWidth*0.78 ,height: 70) //
                        .padding(10)
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
                            
   
                                phrase.category = categorySelected
                                phrase.isCompleted = true
                                try? modelContext.save()
                            WidgetCenter.shared.reloadAllTimelines()
                            
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
                .onAppear {
                    viewModel.inputText = phrase.userEntry
                }
                .translationPresentation(isPresented: $showTranslation, text: phrase.userEntry) { translatedText in
                    
                    phrase.explanation = translatedText
                }
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
