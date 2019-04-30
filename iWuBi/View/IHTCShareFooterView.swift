//
//  IHTCShareFooterView.swift
//  iWuBi
//
//  Created by HTC on 2019/4/14.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit

class IHTCShareFooterView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var shareTitle: UILabel!
    @IBOutlet weak var shareSubTitle: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        Bundle.main.loadNibNamed("IHTCShareFooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    class func footerView(image: UIImage, title: String, subTitle: String) -> IHTCShareFooterView {
        let fview = IHTCShareFooterView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width) * 0.35))
        fview.backgroundColor = .white
        fview.shareImage.image = image
        fview.shareTitle.text = title
        fview.shareSubTitle.text = subTitle
        if UIDevice.current.userInterfaceIdiom == .pad {
            fview.shareTitle.font = UIFont.systemFont(ofSize: 21)
            fview.shareSubTitle.font = UIFont.systemFont(ofSize: 16)
        }
        return fview
    }

}
