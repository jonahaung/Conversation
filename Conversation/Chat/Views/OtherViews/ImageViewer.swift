//
//  ImageViewer.swift
//  Conversation
//
//  Created by Aung Ko Min on 16/2/22.
//

import SwiftUI

struct ImageViewer: View {
    
    let image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
        
    }
}
