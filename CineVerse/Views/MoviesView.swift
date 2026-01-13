//
//  MoviesView.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 13/01/26.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var vm = MoviesViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.movies) { movie in
                        MovieRow(movie: movie)
                            .padding(.horizontal)
                    }

                    if vm.isLoading && vm.movies.isEmpty {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .navigationTitle("Movies")
        }
        .onAppear {
            vm.fetchMoviesPage1To10()
        }
    }
}

#Preview {
    MoviesView()
}
