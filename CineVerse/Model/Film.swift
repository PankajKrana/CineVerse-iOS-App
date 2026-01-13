//
//  Film.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 13/01/26.
//

import Foundation

struct Film: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


struct MovieResponse: Codable {
    let page: Int
    let results: [Film]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// extension for the Url
extension Film {
    var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
}



import Playgrounds

#Playground {
    let apiKey = "your_api_key"
    let url = URL(
        string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&page=1"
    )!
    
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        print(response.results.first?.title ?? "No movie")
    } catch {
        print(error)
    }
    
}
