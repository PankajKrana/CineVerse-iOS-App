import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.movies) { movie in
                        MovieRow(movie: movie)
                    }
                }
            }
            .navigationTitle("Movies")
        }
        .task {
            await viewModel.fetchMovies()
        }
    }
}
