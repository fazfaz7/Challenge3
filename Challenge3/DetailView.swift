//
//  DetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 01/11/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var showCategoryView: Bool = false
    @State var categorySelected: Category = Category(name: "", emoji: "")
   //@State private var animationsRunning = false
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(phrase.learnType == .newPhrase ? "New phrase" : "How to say...?")
                        .foregroundStyle(.green2)
                        .fontWeight(.medium)
                    Text(phrase.userEntry)
                        .font(.title)
                        .fontWeight(.semibold)
                        .italic()
                    

                
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 60)
                        .padding(.horizontal)
                        .shadow(radius: 14)
                        .foregroundStyle(.secondary)
                        .opacity(0.3)
                    
                        
                    
                    Button {
                        showCategoryView = true
                    } label: {
                        
                        if categorySelected.name != "" {
                            Text(categorySelected.emoji)
                                .font(.title)
                        } else {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                        
                        
                    }
                  
                }
 
            }
           
           
            VStack(alignment: .leading, spacing: 25){
                Text("Adrian, write the explanation of the phrase here and finish your pending! Clear your doubt :)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextEditor(text: $phrase.explanation)
                    .frame(height: 100) // Adjust the height as needed
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 1))

                
                
                HStack {
                                    Spacer() // Add a spacer before and after
                                    Button {
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            phrase.category = categorySelected
                                            phrase.isCompleted = true // Mark as checked out
                                                            try? modelContext.save()
                                        }
                                       
                                                        dismiss()
                                    } label: {
                                        HStack {
                                            Text("Check pending")
                                            
                                            
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                                        .foregroundStyle(.white)
                                    }
                                    Spacer() // Spacer after to center the button
                                }
               
            }
            
            /*VStack {
                Image(systemName: "speaker.3")
                    .symbolEffect(.variableColor.iterative, options: .repeating, value: animationsRunning)
            }
            
            Button("Start Animations") {
                    withAnimation {
                        animationsRunning.toggle()
                    }
                }
             */

            Spacer()
            
        }.padding()
            .sheet(isPresented: $showCategoryView) {
                ChooseCategoryView(categorySelected: $categorySelected)
                    .presentationDetents([.fraction(0.3)])
            }
    }
}


#Preview {
    DetailView(phrase: LearnElement(learnType: .newPhrase, userEntry: "Tuttavia", explanation: ""))
    
    //ChooseCategoryView(categorySelected: $categorySelected)
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
