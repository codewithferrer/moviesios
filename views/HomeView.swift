//
//  HomeView.swift
//  movies
//
//  Created by Daniel Ferrer on 20/7/22.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 4.0) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(
                        destination: MovieView(movieId: movie.id)
                    ) {
                        Text(movie.title)
                            .font(.title2)
                    }
                    
                }
                Spacer()
            }
        }.onAppear {
            viewModel.loadMovies()
        }
    }
}


#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        var view = HomeView()
        
        let viewModel = MockHomeViewModel()
        view.viewModel = viewModel
        
        return view
    }
}
#endif

