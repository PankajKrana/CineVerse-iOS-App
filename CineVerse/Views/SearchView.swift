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
            ScrollView {
                if vm.movies.isEmpty && !vm.searchText.isEmpty && !vm.isLoading {
                    // Empty state
                    Text("No movies found")
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.movies) { movie in
                            MovieRow(movie: movie)
                                .padding(.horizontal)
                        }

                        if vm.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(
                text: $vm.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search movies"
            )
        }
    }
}

#Preview {
    SearchView()
}
