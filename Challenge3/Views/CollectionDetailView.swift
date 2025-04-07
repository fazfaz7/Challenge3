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
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
                    VStack(alignment: .center) {

                        VStack(spacing: 20) {
                            VStack {
                                Text("New Phrase")
                                    .padding(.horizontal,10)
                                    .padding(.vertical,5)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(.accent))
                                    .foregroundStyle(.white)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                
                                Text(phrase.userEntry)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                           
                            Divider()
                                .padding(.horizontal,20)
                            }
                            VStack {
                                Text("Explanation/Meaning")
                                    .foregroundStyle(.accent)
                                    .padding(.bottom,3)
                                    .fontWeight(.medium)
                                Text(phrase.explanation)
                                    
                                
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
                        .frame(width: Global.screenWidth*0.80)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(radius: 0.5))
                        
                        
                        
                    }
                    
                    
                    
                    

        }
        
    }
}

#Preview {
    CollectionDetailView(phrase: LearnElement(learnType: .newPhrase ,userEntry: "Tuttavia", explanation: "Pero"))
}
