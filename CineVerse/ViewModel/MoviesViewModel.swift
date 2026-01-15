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

    
    @Published var featuredMovies: [Film] = []
    @Published var popularMovies: [Film] = []
    @Published var searchResults: [Film] = []

    @Published var state: ViewState = .idle
    @Published var searchText = ""

    
    private var currentPage = 1
    private let maxPages = 10
    private var isFetchingPage = false

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    // MARK: - Init
    init() {
        bindSearch()
        fetchTrending()
        fetchPopular(reset: true)
    }

    // MARK: - Search Binding
    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                text.isEmpty
                ? self.searchResults.removeAll()
                : self.searchMovies(query: text)
            }
            .store(in: &cancellables)
    }

    // MARK: - Trending (Featured)
    func fetchTrending() {
        guard let url = makeTrendingURL() else { return }

        state = .loading

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.featuredMovies = response.results
                self?.state = .loaded
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Popular (Paginated)
        func fetchPopular(reset: Bool = false) {
            guard !isFetchingPage else { return }

            if reset {
                currentPage = 1
                popularMovies.removeAll()
            }

            guard currentPage <= maxPages,
                  let url = makeDiscoverURL(page: currentPage) else { return }

            isFetchingPage = true
            state = .loading

            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: MovieResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.isFetchingPage = false
                    if case let .failure(error) = completion {
                        self?.state = .error(error.localizedDescription)
                    }
                } receiveValue: { [weak self] response in
                    self?.popularMovies.append(contentsOf: response.results)
                    self?.currentPage += 1
                    self?.state = .loaded
                }
                .store(in: &cancellables)
        }

        // MARK: - Search
    func searchMovies(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let url = makeSearchURL(query: trimmed) else {
            searchResults.removeAll()
            state = .idle
            return
        }

        searchCancellable?.cancel()
        state = .loading

        searchCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.searchResults = response.results
                self?.state = .loaded
            }
    }

    // MARK: - URL Builders

    private func makeSearchURL(query: String) -> URL? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        return URLComponents(string: "https://api.themoviedb.org/3/search/movie")?
            .addingQueryItems([
                ("api_key", AppSecrets.tmdbApiKey),
                ("query", trimmed),
                ("language", "en-US"),
                ("page", "1")
            ])
    }

    private func makeTrendingURL() -> URL? {
        URLComponents(string: "https://api.themoviedb.org/3/trending/movie/day")?
            .addingQueryItems([
                ("api_key", AppSecrets.tmdbApiKey),
                ("language", "en-US")
            ])
    }

    private func makeDiscoverURL(page: Int) -> URL? {
        URLComponents(string: "https://api.themoviedb.org/3/discover/movie")?
            .addingQueryItems([
                ("api_key", AppSecrets.tmdbApiKey),
                ("language", "en-US"),
                ("page", "\(page)")
            ])
    }

}

extension URLComponents {
    func addingQueryItems(_ items: [(String, String)]) -> URL? {
        var copy = self
        copy.queryItems = items.map { .init(name: $0.0, value: $0.1) }
        return copy.url
    }
}


enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
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

