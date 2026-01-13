//
//  HomeView.swift
//  CineVerse
//
//  Created by Pankaj Kumar Rana on 10/01/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // Hero Carousel
                HeroCarouselView()

                // Sections
                SectionHeader(title: "Continue Watching")
                HorizontalImageRow(height: 100)

                SectionHeader(title: "Trending Now")
                HorizontalImageRow(height: 240)

                SectionHeader(title: "Top 10 TV Shows")
                HorizontalImageRow(height: 240)
            }
            .padding(.bottom, 32)
        }
        .background(Color.black)
        .ignoresSafeArea(edges: .top)
    }
}


struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal)
    }
}


struct HorizontalImageRow: View {
    let height: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: height)
                        .clipped()
                        .cornerRadius(14)
                        .shadow(radius: 6)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct HeroCarouselView: View {

    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        
                        

                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.85)],
                            startPoint: .center,
                            endPoint: .bottom
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            
                            Button {
                                // Watch action
                            } label: {
                                Text("Watch Now")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .glassEffect()
                            }

                        }
                        .foregroundStyle(.white)
                        .padding()
                    }
                    .cornerRadius(22)
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 420)
        .tabViewStyle(.page(indexDisplayMode: .never)).scaleEffect(1.02)
        .animation(.easeInOut(duration: 0.3), value: UUID())


    }
}





#Preview {
    HomeView()
}
