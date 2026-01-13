//
//  MovieRow.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 13/01/26.
//


import SwiftUI

struct MovieRow: View {
    let movie: Film

    var body: some View {
        HStack(spacing: 12) {

            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    Color.gray.opacity(0.3)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                        )

                case .empty:
                    Color.gray.opacity(0.3)

                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 80, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}
