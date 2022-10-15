//
//  HomeView.swift
//  movies
//
//  Created by Daniel Ferrer on 20/7/22.
//

import SwiftUI
import Factory

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel = Container.homeViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 4.0) {
                        ForEach(viewModel.movies) { movie in
                            NavigationLink(
                                destination: MovieView(movieId: movie.id)
                            ) {
                                MovieViewCell(movie: movie)
                            }
                            
                        }
                        
                        if !viewModel.loadMoreState.isRunning &&
                            viewModel.loadMoreState.hasMorePages {
                            Text("").onAppear {
                                viewModel.loadNextPage()
                            }
                        }
                        Spacer()
                    }.padding(.horizontal)
                }
                
                if viewModel.loadMoreState.isRunning {
                    IndeterminateProgressView()
                }
            }
        }.onAppear {
            viewModel.loadMovies()
        }
    }
}

struct IndeterminateProgressView: View {
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ProgressView("", value: downloadAmount, total: 100)
            .frame(height: 2)
            .padding(0)
            
            .onReceive(timer) { _ in
                if downloadAmount < 100 {
                    downloadAmount += 2
                } else {
                    downloadAmount = 0
                }
            }
            .onAppear {
                downloadAmount = 0
            }
    }
}

struct MovieViewCell: View {
    
    var movie: Movie
    
    var body: some View {
        VStack {
            Color.black.opacity(0.0)
                .aspectRatio(1, contentMode: .fill)
                .background(
                    ImageView(urlImage: movie.posterPath)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
            
            
            Text(movie.title)
                .font(.title)
                .foregroundColor(Color.black)
                .lineLimit(1)
        }
    }
}


#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.homeViewModel.register { MockHomeViewModel() }
        HomeView()
    }
}
#endif
