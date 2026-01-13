import Foundation
import Combine

class MoviesViewModel: ObservableObject {

    @Published var movies: [Film] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiKey = "YOUR_API_KEY"
    private var cancellables = Set<AnyCancellable>()

    func fetchMovies() {
        isLoading = true
        errorMessage = nil

        let urlString =
        "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&page=1"

        guard let url = URL(string: urlString) else {
            self.isLoading = false
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
}
