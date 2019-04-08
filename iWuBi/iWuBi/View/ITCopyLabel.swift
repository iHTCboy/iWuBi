//
//  ITCopyLabel.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITCopyLabel: UILabel {

    func attachTapHandler() {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(handlelongPress(recognizer:)))
        self.addGestureRecognizer(longPress)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attachTapHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        attachTapHandler()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attachTapHandler()
    }

    @objc func copying(sender: Any) {
        //print("\(self.text!)")
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.text
        
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copying(sender:))
    }
    
    
    @objc func handlelongPress(recognizer : UIGestureRecognizer) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        let deleteItem = UIMenuItem(title: "Copy", action: #selector(copying(sender:)))
        menu.menuItems = [deleteItem]
        menu.setTargetRect(self.frame, in: self.superview!)
        menu.setMenuVisible(true, animated: true)
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }

}
