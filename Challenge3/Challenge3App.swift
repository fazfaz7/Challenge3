//
//  Challenge3App.swift
//  Challenge3
//
//  Created by Adrian Emmanuel Faz Mercado on 05/12/24.
//

import SwiftUI
import SwiftData

@main
struct Challenge3App: App {
    @StateObject var languageStore = LanguageStore.shared

    var body: some Scene {
        
        WindowGroup {
            TabView {
                Tab("To Review",systemImage: "folder.fill.badge.plus") {
                    ContentView()
                }
                
                Tab("My Collection", systemImage: "books.vertical.fill") {
                    CollectionView()
                }
                
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
        }.modelContainer(for: [LearnElement.self, Category.self])
            .environmentObject(languageStore)
    }
    

}
