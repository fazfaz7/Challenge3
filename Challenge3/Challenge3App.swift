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
    
    init() {
           setupContainer()
       }

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("My Pendings",systemImage: "folder.fill.badge.plus") {
                    ContentView()
                }
                
                Tab("My Collection", systemImage: "books.vertical.fill") {
                    CollectionView()
                }
            }
        }.modelContainer(for: [LearnElement.self, Category.self])
    }
    
    func setupContainer() {
        
    }
}
