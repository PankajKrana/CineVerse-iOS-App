//
//  MainView.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 13/01/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var vm = MoviesViewModel()
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                MoviesView()
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
                    .searchable(text: $vm.searchText)

            }
            
        }
    }
}

#Preview {
    MainView()
}
