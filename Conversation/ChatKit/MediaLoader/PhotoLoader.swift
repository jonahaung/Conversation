//
//  PhotoLoader.swift
//  Conversation
//
//  Created by Aung Ko Min on 3/3/22.
//

import UIKit

class PhotoLoader {
    
    class func start(_ msg: Msg) {

        if let path = Media.path(photoId: msg.id) {
            showMedia(msg, path: path)
        } else {
            loadMedia(msg)
        }
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func manual(_ msg: Msg) {

        Media.clearManual(photoId: msg.id)
        downloadMedia(msg)
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    private class func loadMedia(_ msg: Msg) {

        downloadMedia(msg)
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    private class func downloadMedia(_ msg: Msg) {

        msg.mediaStatus = MediaStatus.Loading
        
        Task {
            do {
                let path = try await MediaDownload.photo(msg.id)
                showMedia(msg, path: path)
            }catch {
                print(error)
            }
        }
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    private class func showMedia(_ msg: Msg, path: String) {
        msg.imageData?.image = UIImage(path: path)
        msg.mediaStatus = MediaStatus.Succeed
    }
}
