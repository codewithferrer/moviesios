//
//  ImageView.swift
//  movies
//
//  Created by Daniel Ferrer on 6/10/22.
//

import SwiftUI
//import Kingfisher

struct ImageView: View {
    
    var urlImage: String?
    var placeholderImage: String = "placeholder"
    
    var body: some View {
        GeometryReader { geo in
             /*if let urlImage = urlImage, let image = URL(string: urlImage) {
                
                KFImage.url(image)
                    .renderingMode(.original)
                    .resizable()
                    .placeholder {
                        Image(placeholderImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                    .clipped()
                    
                
            } else {*/
                Image(placeholderImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                    .clipped()
           // }
            
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                ImageView(urlImage: "https://image.tmdb.org/t/p/original/tVxDe01Zy3kZqaZRNiXFGDICdZk.jpg")
            }.frame(width: 100, height: 100)
            
            VStack {
                ImageView(urlImage: nil)
            }.frame(width: 100, height: 100)
        }
    }
}
