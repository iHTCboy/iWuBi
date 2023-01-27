//
//  TCVoiceUtils.swift
//  iEnglish
//
//  Created by HTC on 2023/1/26.
//  Copyright © 2023 iHTCboy. All rights reserved.
//

import Foundation
import AVFoundation

class TCVoiceUtils: NSObject {

    static let shared = TCVoiceUtils()
    // 参数
    static var setupSuccess: Bool = false
    static var completion: (() -> Void)?
    
    // TTS
    static var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    static var utterance:AVSpeechUtterance = AVSpeechUtterance(string: "")
    
    static func playTTS(text: String, completion: (() -> Void)? = nil) {
        
        // 设置声音
        if !TCVoiceUtils.setupSuccess {
            TCVoiceUtils.setupSuccess = true
            TCVoiceUtils.setupVoiceSystem(allowVoice: true)
        }
        
        if synthesizer.isSpeaking {
            utterance.volume = 0
            synthesizer.delegate = nil
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        
        TCVoiceUtils.completion = completion
        
        synthesizer.delegate = TCVoiceUtils.shared
        utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language:"zh-CN")
//        utterance.volume = 1
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // 范围：0~1
        synthesizer.speak(utterance)
    }
    
    @discardableResult
    static func pauseTTS() -> Bool {
        return synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    @discardableResult
    static func continueTTS() -> Bool {
        return synthesizer.continueSpeaking()
    }
    
    static func stopTTS() {
        if synthesizer.isSpeaking {
            utterance.volume = 0
            synthesizer.delegate = nil
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    static func playSound(audioPath: String, soundId: inout SystemSoundID) {
        let fileUrl = URL.init(fileURLWithPath: audioPath)
        
        AudioServicesCreateSystemSoundID(fileUrl as CFURL, &soundId)

        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, {
            (soundID:SystemSoundID, _:UnsafeMutableRawPointer?) in
        }, nil)
        
        AudioServicesPlaySystemSound(soundId)
    }
    
    //设置声音模式（是否设备静音也播放）
    /// - Parameter allowVoice: 是否设备静音也播放
    static func setupVoiceSystem(allowVoice: Bool) {
        if allowVoice {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setCategory(AVAudioSession.Category.playback)
            try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions(rawValue: 0))
        } else {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setCategory(AVAudioSession.Category.ambient)
            try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions(rawValue: 0))
        }
    }
}

extension TCVoiceUtils: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // 结束播放
        TCVoiceUtils.completion?()
    }
}
