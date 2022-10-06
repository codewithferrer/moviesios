//
//  MovieView.swift
//  movies
//
//  Created by Daniel Ferrer on 21/8/22.
//

import SwiftUI
import Factory

struct MovieView: View {
    
    @ObservedObject var viewModel: MovieViewModel = Container.movieViewModel()
    
    var movieId: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ImageView(urlImage: viewModel.movie?.posterPath)
            
            Color.black.opacity(0.7)
            
            VStack(alignment: .leading, spacing: 4.0) {
                Spacer()
                Text(viewModel.movie?.title ?? "No title")
                    .font(.title)
                Text(viewModel.movie?.overView ?? "No overview")
                    .font(.body)
                Spacer()
            }
            .padding(20)
            .foregroundColor(Color.white)
        }.onAppear {
            viewModel.loadMovie(movieId: movieId)
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.movieViewModel.register { MockMovieViewModel() }
        MovieView(movieId: moviesTest[0].id)
    }
}
#endif
