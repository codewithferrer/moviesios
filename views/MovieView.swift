//
//  MovieView.swift
//  movies
//
//  Created by Daniel Ferrer on 21/8/22.
//

import SwiftUI

struct MovieView: View {
    
    @ObservedObject var viewModel: MovieViewModel = MovieViewModel()
    
    var movieId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(viewModel.movie?.title ?? "No title")
                .font(.title)
            Text(viewModel.movie?.overView ?? "No overview")
                .font(.body)
            Spacer()
        }.onAppear {
            viewModel.loadMovie(movieId: movieId)
        }
    }
}

#if DEBUG
struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        var view = MovieView(movieId: moviesTest[0].id)
        let viewModel = MockMovieViewModel()
        
        view.viewModel = viewModel
        
        return view
    }
}
#endif
