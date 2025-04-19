//
//  OnboardingView.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 19/04/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            TabView {
                VStack {
                    Text("Hola")
                }
                VStack {
                    Text("Adios")
                }
                VStack {
                    Text("Hello")
                }
            }.tabViewStyle(PageTabViewStyle())
        }
    }
}

#Preview {
    OnboardingView()
}
