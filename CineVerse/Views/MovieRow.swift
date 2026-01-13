import SwiftUI

struct MovieRow: View {
    let movie: Film

    var body: some View {
        HStack(spacing: 12) {

            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(movie.title)
                .font(.headline)
                .lineLimit(2)

            Spacer()
        }
        .padding(.vertical, 6)
    }
}
