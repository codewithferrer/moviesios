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
        VStack {
            ForEach(viewModel.movies) { movie in
                Text(movie.title)
            }
        }.onAppear {
            viewModel.loadMovies()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
