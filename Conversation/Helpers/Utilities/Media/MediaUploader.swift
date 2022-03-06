//
//  MediaUploader.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import Foundation
import UIKit

class MediaUploader: NSObject {
    
    private var timer: Timer?
    
    private var uploading = false
    
    static let shared: MediaUploader = {
        let instance = MediaUploader()
        return instance
    } ()

    class func setup() {
        _ = shared
    }
    
    override init() {
        super.init()
        initTimer()
    }
}

extension MediaUploader {
    
    @objc private func initTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            Task {
                await self.uploadNext()
                print("next")
            }
        }
    }
    
    @objc private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func uploadNext() async {
        if (uploading) { return }
        
        if let msgQueue = MediaQueue.fetchOne() {
            guard let id = msgQueue.id else { return }
            guard let cMsg = CMsg.msg(for: id) else {
                return
            }
            let msg = Msg(cMsg: cMsg)
            uploading = true
            do {
                try await upload(msg)
                cMsg.progress = Msg.DeliveryStatus.Sent.rawValue
                msgQueue.update(isQueued: false)
                print("uploaded")
                uploading = false
            }catch {
                print(error)
                cMsg.progress = Msg.DeliveryStatus.SendingFailed.rawValue
                msgQueue.update(isFailed: true)
                uploading = false
            }
        }
    }
}

extension MediaUploader {
    
    private func upload(_ msg: Msg) async throws {
        if (msg.msgType == .Image) { try await uploadPhoto(msg.id) }
        if (msg.msgType == .Video) { try await uploadVideo(msg.id) }
        if (msg.msgType == .Video) { try await uploadAudio(msg.id) }
    }
    
    private func uploadPhoto(_ id: String) async throws {
        if let path = Media.path(photoId: id) {
            if let data = UIImage(path: path)?.jpegData(compressionQuality: 0.8) {
                try await MediaUpload.photo(id, data)
            } else { throw NSError(domain: "Media file error.", code: 102) }
        } else { throw NSError(domain: "Missing media file.", code: 103) }
    }
    
    
    private func uploadVideo(_ id: String) async throws {
        if let path = Media.path(videoId: id) {
            if let data = Data(path: path) {
                if let encrypted = Cryptor.encrypt(data: data) {
                    try await MediaUpload.video(id, encrypted)
                } else { throw NSError(domain: "Media encryption error.", code: 101) }
            } else { throw NSError(domain: "Media file error.", code: 102) }
        } else { throw NSError(domain: "Missing media file.", code: 103) }
    }
    
    
    private func uploadAudio(_ id: String) async throws {
        if let path = Media.path(audioId: id) {
            if let data = Data(path: path) {
                if let encrypted = Cryptor.encrypt(data: data) {
                    try await MediaUpload.audio(id, encrypted)
                } else { throw NSError(domain: "Media encryption error.", code: 101) }
            } else { throw NSError(domain: "Media file error.", code: 102) }
        } else { throw NSError(domain: "Missing media file.", code: 103) }
    }
}
