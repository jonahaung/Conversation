//
//  MediaUploader.swift
//  Conversation
//
//  Created by Aung Ko Min on 17/2/22.
//

import Foundation

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
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
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
    
    private func uploadNext() async {
        if (uploading) { return }
        if let mediaQueue = MediaQueue.fetchOne() {
            guard let id = mediaQueue.id else { return }
            guard let dbmessage = PersistenceController.shared.fetch(id: id) else {
                return
            }
            print(dbmessage)
            let msg = Msg(cMsg: dbmessage)
            uploading = true
            do {
                try await upload(msg)
                dbmessage.progress = Msg.MsgProgress.Sent.rawValue
                mediaQueue.update(isQueued: false)
            }catch {
                dbmessage.progress = Msg.MsgProgress.SendingFailed.rawValue
                mediaQueue.update(isFailed: true)
            }
        }
    }
}

extension MediaUploader {
    
    private func upload(_ msg: Msg) async throws {
        if (msg.msgType == .Image) { try await uploadPhoto(msg) }
        if (msg.msgType == .Video) { try await uploadVideo(msg) }
        if (msg.msgType == .Video) { try await uploadAudio(msg) }
    }
    
    private func uploadPhoto(_ msg: Msg) async throws {
        if let path = Media.path(photoId: msg.id) {
            if let data = Data(path: path) {
                try await MediaUpload.photo(msg.id, data)
            } else { throw NSError(domain: "Media file error.", code: 102) }
        } else { throw NSError(domain: "Missing media file.", code: 103) }
    }
    
    
    private func uploadVideo(_ msg: Msg) async throws {
        if let path = Media.path(videoId: msg.id) {
            if let data = Data(path: path) {
                if let encrypted = Cryptor.encrypt(data: data) {
                    try await MediaUpload.video(msg.id, encrypted)
                } else { throw NSError(domain: "Media encryption error.", code: 101) }
            } else { throw NSError(domain: "Media file error.", code: 102) }
        } else { throw NSError(domain: "Missing media file.", code: 103) }
    }
    
    
    private func uploadAudio(_ msg: Msg) async throws {
        if let path = Media.path(audioId: msg.id) {
            if let data = Data(path: path) {
                if let encrypted = Cryptor.encrypt(data: data) {
                    try await MediaUpload.audio(msg.id, encrypted)
                } else { throw NSError(domain: "Media encryption error.", code: 101) }
            } else { throw NSError(domain: "Media file error.", code: 102) }
        } else { throw NSError(domain: "Missing media file.", code: 103) }
    }
}
