//
//  OnboardingView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 19/04/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            Color.accent.ignoresSafeArea()
            VStack {

                TabView {
                    
                    VStack {
                        VStack(spacing: 30) {
                            
                            VStack(spacing: 20) {
                                
                                Text("🌍")
                                    .font(.system(size: 72))
                                
                                Text("Boost your language skills through your experiences")
                                    .font(.system(size: 28))
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                    
                                
                                
                            }
                            
                            Text("Capture new words and phrases as you go about your day.")
                                .font(.system(size: 18))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .italic()
                            
                
                            
                        }.padding(.horizontal,30)
                        
                        
                        
                    }.frame(width: Global.screenWidth*0.75, height: Global.screenHeight*0.55)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4))
                    
                    
                    
                    
                    
                    
                    VStack {
                        VStack(spacing: 30) {
                            
                            VStack(spacing: 20) {
                                
                                
                                
                                Text("📖")
                                    .font(.system(size: 72))
                                
                                Text("Don’t understand a word or phrase?")
                                    .font(.system(size: 28))
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                    
                                
                                
                            }
                            
                            Text("Heard, saw, or read something unfamiliar? Just save it for later.")
                                .font(.system(size: 18))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .italic()
                            
                
                            
                        }.padding(.horizontal,30)
                        
                        
                        
                    }.frame(width: Global.screenWidth*0.75, height: Global.screenHeight*0.55)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4))
                    
                    
                    
                    
                    VStack {
                        VStack(spacing: 30) {
                            Text("✍️")
                                .font(.system(size: 72))
                            
                            
                            Text("Want to say something but don’t know how?")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                            
                            
                         
                            VStack(spacing: 20) {
                                
                                
                                
                                Text("Write it down in your native language and save it for later...")
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.gray)
                                    .italic()
                                

                                    
                                
                                
                            }
                            

                
                            
                        }.padding(.horizontal,30)
                        
                        
                        
                    }.frame(width: Global.screenWidth*0.75, height: Global.screenHeight*0.55)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4))
                    
                    
                    VStack {
                        VStack(spacing: 30) {
                            Text("🗂️")
                                .font(.system(size: 72))
                            
                            
                            Text("Complete your saved items")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                            
                            
                         
                            VStack(spacing: 20) {
                                
                                
                                
                                Text("When you're ready, add a translation, meaning, or explanation — however works best for you.")
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.gray)
                                    .italic()
                                
                                
                            }
                            

                
                            
                        }.padding(.horizontal,30)
                        
                        
                        
                    }.frame(width: Global.screenWidth*0.75, height: Global.screenHeight*0.55)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4))
                    
                    
                    
                    VStack {
                        VStack(spacing: 30) {
                            Text("🌱")
                                .font(.system(size: 72))
                            
                            
                            Text("Your language journey, all in one place")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                            
                            
                         
                            VStack(spacing: 20) {
                                
                                
                                
                                Text("Revisit everything you’ve learned — saved and ready whenever you need it.")
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.gray)
                                    .italic()
                                
                                
                            }
                            

                
                            
                        }.padding(.horizontal,30)
                        
                        
                        
                    }.frame(width: Global.screenWidth*0.75, height: Global.screenHeight*0.55)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4))
                        
                    VStack {
                        WelcomeView()
                            .padding()
                                .background(RoundedRectangle(cornerRadius: 20).fill(.white).shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4))
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
    }
}

#Preview {
    OnboardingView()
}



