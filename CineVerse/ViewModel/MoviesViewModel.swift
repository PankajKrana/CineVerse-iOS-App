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
    @Published var searchText = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                if text.isEmpty {
                    self.fetchMoviesPage1To10()
                } else {
                    self.searchMovies(query: text)
                }
            }
            .store(in: &cancellables)
    }


    func searchMovies(query: String) {
        isLoading = true
        errorMessage = nil

        guard let url = makeSearchURL(query: query) else {
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.movies = response.results
            }
            .store(in: &cancellables)
    }


    func fetchMoviesPage1To10() {
        movies.removeAll()
        fetchDiscoverPage(page: 1)
    }

    private func fetchDiscoverPage(page: Int) {
        guard page <= 10 else { return }

        isLoading = true

        guard let url = makeDiscoverURL(page: page) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.movies.append(contentsOf: response.results)
                self?.fetchDiscoverPage(page: page + 1)
            }
            .store(in: &cancellables)
    }

    // MARK: - URL Builders

    private func makeSearchURL(query: String) -> URL? {
        var components = URLComponents(string: "https://api.themoviedb.org/3/search/movie")
        components?.queryItems = [
            .init(name: "api_key", value: AppSecrets.tmdbApiKey),
            .init(name: "query", value: query),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "1")
        ]
        return components?.url
    }

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
