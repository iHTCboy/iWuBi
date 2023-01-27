//
//  IHTCTTSViewController.swift
//  iWuBi
//
//  Created by HTC on 2023/1/27.
//  Copyright © 2023 HTC. All rights reserved.
//

import UIKit

class IHTCTTSViewController: UIViewController {

    
    lazy var playItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.play, target: self, action: #selector(playPlaylist))
        return item
    }()
    
    lazy var stopItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.stop, target: self, action: #selector(stopPlaylist))
        return item
    }()
    
    lazy var pauseItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.pause, target: self, action: #selector(pausePlaylist))
        return item
    }()
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.delegate = self
        text.isEditable = true
        text.alwaysBounceVertical = true
        text.font = UIFont.systemFont(ofSize: 20)
        text.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            text.backgroundColor = .secondarySystemGroupedBackground
        }
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "文字转语音(TTS)"
        self.navigationItem.rightBarButtonItem = playItem
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemGroupedBackground
        }
        
        view.addSubview(textView)
        let constraintViews = [
            "textView": textView
        ]
        let vFormat = "V:|-0-[textView]-0-|"
        let hFormat = "H:|-5-[textView]-5-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: [:], views: constraintViews)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: [:], views: constraintViews)
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        view.layoutIfNeeded()
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        TCVoiceUtils.stopTTS()
    }

}

// 播放列表操作
extension IHTCTTSViewController {
    
    @objc
    func playPlaylist() {
        let words = textView.text ?? ""
        guard !words.isEmpty else {
            return
        }
        TCVoiceUtils.playTTS(text: words) { [weak self] in
            self?.navigationItem.rightBarButtonItem = self?.playItem
        }
        self.navigationItem.rightBarButtonItem = stopItem
    }
    
    @objc
    func stopPlaylist() {
        if TCVoiceUtils.pauseTTS() {
            self.navigationItem.rightBarButtonItem = pauseItem
        } else {
            self.navigationItem.rightBarButtonItem = playItem
        }
    }
    
    @objc
    func pausePlaylist() {
        if TCVoiceUtils.continueTTS() {
            self.navigationItem.rightBarButtonItem = stopItem
        } else {
            self.navigationItem.rightBarButtonItem = playItem
        }
    }
}

extension IHTCTTSViewController: UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
