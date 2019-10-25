//
//  RecordAudio.swift
//  T-Chat
//
//  Created by Pavel Ivanov on 24.10.2019.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import Foundation
import AVFoundation

class RecordAndPlayAudioMessege: NSObject {
    var soundRecord: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    let filename = "audioFile.m4a"
    
    override init() {
        super.init()
        self.setupRecorder()
    }
    
    func recordAudio() {
        soundRecord.record()
    }
    
    func palayAudio() {
        setupPlayer()
        soundPlayer.play()
    }
    
    fileprivate func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask)
        return paths[0]
    }

    fileprivate func setupRecorder() {
        let audioFileame = getDocumentDirectory().appendingPathComponent(filename)
        let recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless,
                             AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                             AVEncoderBitRateKey : 320000,
                             AVNumberOfChannelsKey : 2,
                             AVSampleRateKey : 44100.2] as [String : Any]

        do {
            soundRecord = try AVAudioRecorder(url: audioFileame, settings: recordSetting)
            soundRecord.delegate = self
            soundRecord.prepareToRecord()
        } catch {
            print(error)
        }
    }

    fileprivate func setupPlayer() {
        let audioFilename = getDocumentDirectory().appendingPathComponent(filename)

        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print(error)
        }
    }
}

extension RecordAndPlayAudioMessege: AVAudioRecorderDelegate {
    
}

extension RecordAndPlayAudioMessege: AVAudioPlayerDelegate {
    
}
