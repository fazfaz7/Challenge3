//
//  AboutView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 07/04/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        

            VStack(spacing: 20) {
                Spacer()
                VStack(spacing: 20) {
                    Image("LyngoIcon")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 100)
                    
                    Text("About ItMeans")
                        .font(.title)
                        .fontWeight(.bold)
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("What is ItMeans?")
                                .foregroundStyle(.accent)
                                .fontWeight(.semibold)
                                .font(.title3)
                            
                            Text("ItMeans is your personal space to save the words, phrases, and expressions you encounter while immersing yourself in a new language.")
                                .font(.callout)
                            
                            
                        }
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("How it works?")
                                .foregroundStyle(.accent)
                                .fontWeight(.semibold)
                                .font(.title3)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("✍️ Save any new words, phrases, or slang you discover.")
                                Text("📚 Review your collection as you learn")
                                Text("🤝 Complete your pendings by asking a native speaker or by searching")
                                Text("🧠 Activate the widget to practice your saved words daily.")
                            }.font(.callout)
                            
                            
                            
                        }
                        
                        
                    }
                    .padding(20)
                    .padding(.vertical,5)
                    
                }.frame(width: Global.screenWidth*0.90)
                    Spacer()
                    Text("Version 1.0 © 2025 ItMeans")
                        .padding()
                
            }
        
    }
}

#Preview {
    AboutView()
}
