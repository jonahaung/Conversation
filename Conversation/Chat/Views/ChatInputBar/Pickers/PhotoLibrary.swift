//
//  PhotoLibrary.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI
import UI

struct PhotoLibrary: View {
    
    @State private var image: UIImage?
    @State private var size: CGSize?
    @EnvironmentObject private var outgoingSocket: OutgoingSocket
    @EnvironmentObject internal var roomProperties: RoomProperties
    var body: some View {
        VStack {
            if let image = image {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .saveSize(viewId: "PhotoLibrary")
                    
                    Button("Clear") {
                        withAnimation(.interactiveSpring()) {
                            self.image = nil
                        }
                    }
                }
                Button("Send Image") {
                    send(image: image)
                }
                    
            } else {
                Text("Select image from library")
                    .tapToPresent(
                        ImagePickerSingle(autoDismiss: true) { image in
                            withAnimation(.interactiveSpring()) {
                                self.image = image
                            }
                        }
                    )
            }
        }
        .padding(.horizontal)
        .retrieveSize(viewId: "PhotoLibrary", $size)
    }
    
    private func send(image: UIImage) {
        Task {
            let msg = Msg(conId: roomProperties.id, msgType: .Image, rType: .Send, progress: .Sending)
            msg.imageData = .init(urlString: "https://www.lookslikefilm.com/wp-content/uploads/2020/01/Sarah-Kossak-Gupta.jpg")
            msg.imageData?.image = image
            let size = self.size ?? .zero
            msg.imageRatio = size.width / size.height
            if let data = image.pngData() {
                Media.save(photoId: msg.id, data: data)
            }
            
            await outgoingSocket.add(msg: msg)
            self.image = nil
        }
    }
}
