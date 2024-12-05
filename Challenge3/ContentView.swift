//
//  ContentView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hey Adrian")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                            Text("Italian Learner")
                                .font(.title3)
                                .foregroundStyle(.accent)
                            
                        }
                        Spacer()
                        
                    }.frame(width: Global.screenWidth*0.67, height: Global.screenHeight*0.08)
                    
                    
                    ZStack {
                        Circle()
                            .fill(  .accent.mix(with: .white, by: 0.8))
                            
                            .overlay {
                                Circle()
                                    .foregroundStyle(.accent)
                                    .scaleEffect(0.40)
                                    .overlay {
                                        Text("10")
                                            .foregroundStyle(.white)
                                            .font(.callout)
                                    }
                                    .offset(x: 25, y: -30)
                            }
                        Image(systemName: "flame.fill")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundStyle(.accent)

                    }.frame(width: Global.screenWidth*0.18)
                  
                }
                
                HStack(spacing: 12) {
                    
                    Button {
                     
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "book.fill")
                                .font(.title)
                            Text("New phrase")
                                
                        }.foregroundStyle(.white)
                            .frame(width: Global.screenWidth*0.42, height: Global.screenHeight*0.09)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accent).opacity(0.8).shadow(radius:1))
                    }
                    
                    
                    Button {
                      
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .font(.title)
                            Text("How to say?")
                                
                        }.foregroundStyle(.white)
                            .frame(width: Global.screenWidth*0.42, height: Global.screenHeight*0.09)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accent)
                            .opacity(0.8).shadow(radius:1))
                    }

                }.padding(.vertical)
                
                HStack {
                    VStack {
                        Text("My Pendings")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }.frame(width: Global.screenWidth*0.85)
                
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}



