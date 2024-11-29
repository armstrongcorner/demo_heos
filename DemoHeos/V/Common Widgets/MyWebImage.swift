//
//  MyWebImage.swift
//  DemoHeos
//
//  Created by Armstrong Liu on 29/11/2024.
//

import SwiftUI

struct MyWebImage: View {
    let imgUrl: String?
    
    init (imgUrl: String? = nil) {
        self.imgUrl = imgUrl
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imgUrl ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.gray.opacity(0.1))
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
}

#Preview {
    MyWebImage(imgUrl: "https://source.unsplash.com/random/80x80")
}
