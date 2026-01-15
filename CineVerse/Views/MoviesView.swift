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
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {

                    
                    Text("Trending")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(vm.featuredMovies) { movie in
                                FeaturedMovieCard(movie: movie)
                            }
                        }
                        .padding(.horizontal)
                    }

                    
                    Text("Popular Now")
                        .font(.title2.bold())
                        .padding(.horizontal)

                    LazyVStack(spacing: 20) {
                        ForEach(vm.popularMovies) { movie in
                            MoviePosterRow(movie: movie)
                                .padding(.horizontal)
                        }
                    }

                    if vm.state == .loading {
                        ProgressView()
                            .padding(.top, 40)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Watch Now")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            vm.fetchTrending()
            vm.fetchPopular(reset: true)
        }
    }
}


struct FeaturedMovieCard: View {
    let movie: Film

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding()
        }
        .frame(width: 300, height: 420)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 12)
    }
}

struct MoviePosterRow: View {
    let movie: Film

    var body: some View {
        HStack(spacing: 16) {

            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 110, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)

                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}


#Preview {
    MoviesView()
}
