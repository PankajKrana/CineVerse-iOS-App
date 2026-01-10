//
//  ContentView.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 10/01/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Store", systemImage: "r3.button.angledbottom.horizontal.right") {
                Text("StoreView")
            }
            
            Tab("Downloads", systemImage: "arrow.down.circle") {
                Text("Download View")
            }
            
            Tab("search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
                    .searchable(text: .constant(""))
            }
        }
    }
}

#Preview {
    ContentView()
}
