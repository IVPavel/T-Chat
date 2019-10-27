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
    fileprivate var soundRecord: AVAudioRecorder!
    fileprivate var soundPlayer: AVAudioPlayer!
    
    fileprivate let filename = "record.m4a"
    
    func recordAudio() {
        self.setupRecorder()
        soundRecord.record()
    }
    
    func stopAudioRecord() {
        soundRecord.stop()
    }
    
    func palayAudio() {
        self.setupPlayer()
        soundPlayer.play()
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getLocalFile() -> URL {
        return getDocumentDirectory().appendingPathComponent(filename)
    }

    fileprivate func setupRecorder() {
        let audioFileame = getDocumentDirectory().appendingPathComponent(filename)
        let recordSetting = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                             AVSampleRateKey: 12000,
                             AVNumberOfChannelsKey: 1,
                             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

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
