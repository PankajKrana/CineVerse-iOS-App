//
//  MoviesViewModel.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 13/01/26.
//


import Foundation
import Combine

@MainActor
final class MoviesViewModel: ObservableObject {

    
    @Published var movies: [Film] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    
    private var cancellables = Set<AnyCancellable>()
    private let maxPage = 20
    private var currentPage = 1

    

    func fetchMoviesPage1To10() {
        movies.removeAll()
        currentPage = 1
        errorMessage = nil
        fetchNextPage()
    }

    // MARK: - Core pagination logic

    private func fetchNextPage() {
        guard currentPage <= maxPage else {
            isLoading = false
            return
        }

        isLoading = true

        guard let url = makeDiscoverURL(page: currentPage) else {
            isLoading = false
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.movies.append(contentsOf: response.results)
                self.currentPage += 1
                self.fetchNextPage()
            }
            .store(in: &cancellables)
    }

    // MARK: - URL Builder (v3 API key)
    private func makeDiscoverURL(page: Int) -> URL? {
        var components = URLComponents(string: "https://api.themoviedb.org/3/discover/movie")
        components?.queryItems = [
            .init(name: "api_key", value: AppSecrets.tmdbApiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
        return components?.url
    }
}



enum AppSecrets {
    static let tmdbApiKey: String = {
        guard let key = Bundle.main
            .object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
              !key.isEmpty else {
            fatalError("TMDB_API_KEY is missing. Check Secrets.xcconfig and Target → Info.")
        }
        return key
    }()
}
