//
//  ContentView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import SwiftUI
import SwiftData
import NaturalLanguage
import WidgetKit

struct ContentView: View {
    @State var showNewPhrase: Bool = false
    @State var newPhraseText: String = ""
    @State var newType: Int = 1
    @Query(
        filter: #Predicate { $0.isCompleted == false },
        sort: \LearnElement.dateAdded,
        order: .reverse,
        animation: .default
    ) var testPhrases: [LearnElement]
    @State var phrases: [String] = ["Mi raccomando", "Lascia perdere?", "In bocca al lupo", "Merluzzo", "Suino/Maiale?", "Stupidino"]
    @Environment(\.modelContext) var modelContext
    @Query(
        sort: \Category.dateAdded,
        animation: .default
    ) var myCategories: [Category]
    @Query(
        filter: #Predicate { $0.isCompleted == true },
        sort: \LearnElement.dateAdded,
        order: .reverse,
        animation: .default
    ) var collectionPhrases: [LearnElement]
    @State var newPhrasesExpanded: Bool = false
    @State var howToSayExpanded: Bool = false
    @AppStorage("userName") private var userName: String = "No name set"
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "Italian 🇮🇹"
    @State private var isPresenting = true
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hey \(userName)")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .minimumScaleFactor(0.85)
                            Text("\(selectedLanguage.dropLast(2)) Learner")
                                .font(.title3)
                                .foregroundStyle(.accent)
                            
                        }
                        Spacer()
                        
                        
                        

                        
                    }.frame(width: Global.screenWidth*0.67, height: Global.screenHeight*0.08)
                    
                    Spacer()
                    
                    Button {
                        isPresenting = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.accent)
                    }
                    
                }.frame(maxWidth: Global.screenWidth*0.85)
                
                HStack(spacing: 12) {
                    
                    Button {
                        newType = 1
                        showNewPhrase = true
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "book.fill")
                                .font(.title)
                            Text("New phrase")
                            
                        }.foregroundStyle(.white)
                            .frame(width: Global.screenWidth*0.42, height: Global.screenHeight*0.09)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accent).opacity(0.8).shadow(radius:1))
                    }
                    .accessibilityLabel("New Phrase. Add a New Phrase that you do not understand the meaning.")
                    
                    
                    Button {
                        newType = 2
                        showNewPhrase = true
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .font(.title)
                            Text("How to say?")
                            
                        }.foregroundStyle(.white)
                            .frame(width: Global.screenWidth*0.42, height: Global.screenHeight*0.09)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accent)
                                .opacity(0.8).shadow(radius:1))
                    }.accessibilityLabel("How to say? Add a phrase or word in your native language to learn how to say it in your new language.")
                    
                }.padding(.vertical)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("My Pendings")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    
                    Text("\(testPhrases.count)")
                        .padding(9)
                        .background(Circle().fill(.gray.opacity(0.6)))
                        .font(.caption)
                        .foregroundStyle(.white)
                    Spacer()
                }.frame(width: Global.screenWidth*0.85)
                    .padding(.bottom,5)
                
                if testPhrases.isEmpty {
                    VStack(alignment: .center, spacing: 10) {
                        Spacer()
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        
                        Text("No pendings!")
                            .fontWeight(.semibold)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Consider adding new phrases to your collection. There's always something new to learn! ")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }.padding()
                    
                } else {
                    
                    if !howToSayExpanded && !testPhrases.filter({ $0.learnType == .newPhrase }).isEmpty {
                    
                    HStack {
                        VStack {
                            Text("New Phrases")
                                .font(.title3)
                                .fontWeight(.regular
                                )
                                .foregroundStyle(.accent)
                        }
                        
                        
                        
                        Spacer()
                        Button {
                            withAnimation {
                                newPhrasesExpanded.toggle()
                            }
                        } label: {
                            
                            if newPhrasesExpanded {
                                Image(systemName: "rectangle.compress.vertical")
                                    .foregroundStyle(.accent)
                            } else {
                                Image(systemName: "rectangle.expand.vertical")
                                    .foregroundStyle(.accent)
                            }
                            
                        }
                    }.frame(width: Global.screenWidth*0.85)
                    ScrollView {
                        VStack(spacing: 15) {
                            
                            ForEach(testPhrases, id: \.self) { phrase in
                                
                                if phrase.learnType == .newPhrase {
                                    WordElementView(phrase: phrase, isCollection: false)
                                }
                                
                                
                            }
                            
                        }
                        
                    }.frame(height: newPhrasesExpanded ? Global.screenHeight*0.45 : Global.screenHeight*0.19)
                    
                }
                    
                    if !newPhrasesExpanded && !testPhrases.filter({ $0.learnType == .howToSay }).isEmpty{
                    HStack {
                        VStack {
                            Text("How To Say...")
                                .font(.title3)
                                .fontWeight(.regular
                                )
                                .foregroundStyle(.accent)
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                howToSayExpanded.toggle()
                            }
                        } label: {
                            if howToSayExpanded {
                                Image(systemName: "rectangle.compress.vertical")
                                    .foregroundStyle(.accent)
                            } else {
                                Image(systemName: "rectangle.expand.vertical")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }.frame(width: Global.screenWidth*0.85)
                    
                    
                        ScrollView {
                            VStack(spacing: 15) {
                                
                                ForEach(testPhrases, id: \.self) { phrase in
                                    
                                    if phrase.learnType == .howToSay {
                                        WordElementView(phrase: phrase, isCollection: false)
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }.frame(height: howToSayExpanded ? Global.screenHeight*0.45 : Global.screenHeight*0.19)
                    }
                }
                
            }
            .sheet(isPresented: $showNewPhrase) {
                NewPhraseView(newPhraseText: $newPhraseText, showNewPhrase: $showNewPhrase, phrases: $phrases, newType: $newType)
                
                    .presentationDetents([.fraction(0.38)])
            }
            
            Spacer()
        }.onAppear {
            
            let fetchRequest = FetchDescriptor<Category>()
            do {
                let existingCategories = try modelContext.fetch(fetchRequest)
                let existingCategoryNames = Set(existingCategories.map { $0.name }) // Collect existing category names
                
                // Filter categories to insert, excluding those already present
                let categoriesToInsert = categories.filter { !existingCategoryNames.contains($0.name) }
                
                for category in categoriesToInsert {
                    modelContext.insert(category)
                }
                
                // Save the context if there are new categories
                if !categoriesToInsert.isEmpty {
                    try modelContext.save()
                }
            } catch {
                print("Error fetching or saving categories: \(error)")
            }
            
            
            
            
        }
        .onAppear {
                        // Check if both userName and selectedLanguage are set
                        if userName == "No name set" || selectedLanguage == "No language selected" {
                            isPresenting = true // Show the welcome screen
                        } else {
                            isPresenting = false // Skip the welcome screen if both are set
                        }
                    }
        .fullScreenCover(isPresented: $isPresenting, onDismiss: didDismiss) {
            WelcomeView()
        }

    }
    
    func didDismiss() {
        dismiss()
        }
    
    
}

#Preview {
    ContentView()
}

struct WordElementView: View {
    var phrase: LearnElement
    var isCollection: Bool = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        ZStack {
            HStack {
                Rectangle()
                    .fill(phrase.learnType == .howToSay ? .accent : .accent).opacity(0.7)
                    .clipShape(.rect(topLeadingRadius: 10, bottomLeadingRadius: 10))
                    .frame(width: 10)
                
                Spacer()
            }
            
            
            NavigationLink {
                if !isCollection {
                    DetailView(phrase: phrase)
                } else {
                    CollectionDetailView(phrase: phrase)
                }
            } label: {
                HStack {
                    Text(phrase.userEntry)
                        .foregroundStyle(.primary)
                        .padding(.horizontal,8)
                    Spacer()
                    
                    
                }
                .padding()
                .frame(width: Global.screenWidth*0.85, height: Global.screenHeight*0.08)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary
                    .opacity(0.1)).shadow(radius:1))
                .foregroundStyle(.primary)
            }
        }
        .padding()
        .frame(width: Global.screenWidth*0.85, height: Global.screenHeight*0.08)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.1)).shadow(radius:1))
        .foregroundStyle(.primary)
        .contextMenu {
            Button {
                withAnimation {
                    modelContext.delete(phrase)
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error deleting element: \(error)")
                    }
                }
            } label: {
                
                Label(isCollection ? "Delete from collection" : "Delete pending", systemImage: "trash.fill")
            }
        }
    }
}



struct NewPhraseView: View {
    @Binding var newPhraseText: String
    @Binding var showNewPhrase: Bool
    @Binding var phrases: [String]
    @Binding var newType: Int
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var showMessage: Bool = false
    let maxCharacters = 50
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading)  {
                    
                    HStack(spacing: 15) {
                        Text(newType == 1 ? "Add New Phrase" : "How to say?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 3)
                                .opacity(0.5)
                                .foregroundColor(.gray)
                                .frame(width: 12)
                            
                            Circle()
                                
                                    .trim(from: 0.0, to: CGFloat(min(Double(newPhraseText.count) / Double(maxCharacters), 1.0)))
                                    .stroke(
                                        AngularGradient(gradient: Gradient(colors: [.accent, .accent]), center: .center),
                                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                    )
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: 12)
                        }
                    }
                    
                        Text(newType == 1 ? "Heard a phrase you don't understand? Have a word you're unsure about? Save it here for later!" : "You want to know how to say a specific word or phrase in your new language? Save it here for later!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                
                        

                    
                }
                
                Spacer()
            }
            
            if showMessage {
                Text("Make sure your word/phrase is in Italian!")
                    .foregroundStyle(.red)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            
            TextEditor(text: Binding(
                get: { newPhraseText },
                set: { newValue in
                    // Trim to max length
                    if newValue.count <= maxCharacters {
                        newPhraseText = newValue
                    } else {
                        newPhraseText = String(newValue.prefix(maxCharacters))
                        // Optional: give haptic or visual feedback
                    }
                }
            ))
                .frame(height: 70)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 1))
            
            HStack {
            Button {
                    let newElement = LearnElement(learnType: newType == 1 ? .newPhrase : .howToSay, userEntry: newPhraseText, explanation: "")
                    
                    withAnimation {

                            modelContext.insert(newElement)
                    }
                    
                    WidgetCenter.shared.reloadAllTimelines()
                    newPhraseText = ""
                    showNewPhrase = false

            } label: {
                HStack {
                    Text("Add to Pendings ")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "plus")
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(newPhraseText == "" ? Color.gray : Color.accentColor))
                .disabled(newPhraseText.isEmpty)
                

            }
                
            }.padding(.top,10)
            
        }.padding()
    }
    

}
