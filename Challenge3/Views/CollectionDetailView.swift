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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(phrase.learnType == .newPhrase ? "New Phrase" : "How to Say?...")
                            .foregroundStyle(.accent)
                            .font(.title3)
                        
                        
                        
                        Text(phrase.userEntry)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .italic()
                    }.padding(5)
                    
                    
                    
                    VStack(alignment: .leading) {
                        
                        Text("Explanation/Meaning")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .padding(.bottom,3)
                        
                        Text(phrase.explanation)
                            .font(.title3)
                        
                    }.padding(5)
                    
                    
                    VStack(alignment: .leading) {
                        
                        Text("Category")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .padding(.bottom,3)
                        
                        HStack {
                            
                            if let category = phrase.category {
                                Text(category.emoji)
                                Text(category.name)
                            }
                        }
                        .font(.title3)
                        
                    }.padding(5)
                    
                   
                    
                    
                }
                Spacer()
            }
            
            Spacer()
        }.padding(20)
            .frame(width: 400)
    }
}

#Preview {
    CollectionDetailView(phrase: LearnElement(learnType: .newPhrase ,userEntry: "Tuttavia", explanation: "Pero"))
}
