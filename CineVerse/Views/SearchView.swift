//
//  SearchView.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 11/01/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = MoviesViewModel()

    var body: some View {
        NavigationStack {
            Group {

                // Empty state
                if vm.searchText.isEmpty {
                    ContentUnavailableView(
                        "Search Movies",
                        systemImage: "magnifyingglass",
                        description: Text("Type a movie name to start searching")
                    )

                } else if vm.searchResults.isEmpty && vm.state != .loading {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "film",
                        description: Text("Try a different movie name")
                    )

                } else {
                    List(vm.searchResults) { movie in
                        MovieRow(movie: movie)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .task {
                
            }
            .navigationTitle("Search")
            .searchable(
                text: $vm.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search movies"
            )
            .overlay {
                if vm.state == .loading {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
