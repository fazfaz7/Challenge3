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


    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
                    VStack(alignment: .center) {

                        VStack(spacing: 20) {
                            VStack {
                                
                                HStack {
                                    Button {
                                        isEditing = true
                                    } label: {
                                        Image(systemName: "pencil")
                                            .font(.title3)
                                    }
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
                                    Text("New Expression")
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
                        .frame(maxHeight: Global.screenHeight*0.55)
                        
                        
                        
                        
                    }
                    
                    
                    
                    

        }.sheet(isPresented: $isEditing) {
            EditPhraseView(phrase: phrase)
        }

        
    }
}

#Preview {
    CollectionDetailView(phrase: LearnElement(learnType: .newPhrase ,userEntry: "Ancora non so cosa sto facendo qua. ma ti voglio aiutare semopre", explanation: "Pero, locura! Nosotros nunca sabemos que está sucediendo por aca lol", language: "Italian 🇮🇹"))
}



struct EditPhraseView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Category.dateAdded) var categories: [Category]
    
    @State private var editedEntry: String = ""
    @State private var editedExplanation: String = ""
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expression")) {
                    TextField("Enter phrase", text: $editedEntry)
                }
                
                Section(header: Text("Explanation")) {
                    TextField("Enter explanation", text: $editedExplanation)
                }
                
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            HStack {
                                //Text(category.emoji)
                                Text("\(category.emoji) \(category.name)")
                            }.tag(Optional(category))
                        }
                    }
                }
            }
            .navigationTitle("Edit Phrase")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                editedEntry = phrase.userEntry
                editedExplanation = phrase.explanation
                selectedCategory = phrase.category
            }
        }
    }
}
