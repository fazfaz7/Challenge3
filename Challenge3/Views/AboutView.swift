//
//  AboutView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 07/04/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 20) {
                    Image("LyngoIcon")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 100)
                    
                    Text("About WordNest")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What is WordNest?")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                            .font(.title3)
                        
                        Text("WordNest is your personal space to save the words, phrases, and expressions you encounter while immersing yourself in a new language.")
                            .font(.callout)
                            .multilineTextAlignment(.leading)
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
                .frame(width: Global.screenWidth*0.80)
                .background(RoundedRectangle(cornerRadius: 28).fill(.white).shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4))
                Spacer()
                Text("Version 1.0 © 2025 WordNest")
            }
        }
    }
}

#Preview {
    AboutView()
}
