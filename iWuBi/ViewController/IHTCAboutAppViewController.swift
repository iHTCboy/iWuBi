//
//  ITAboutAppVC.swift
//  iTalker
//
//  Created by HTC on 2017/4/23.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class IHTCAboutAppViewController: UIViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var copylightLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension IHTCAboutAppViewController
{
    func setupUI() {

        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.secondarySystemGroupedBackground
        }
        
        self.title = "关于\(kiTalker)"
        
        guard (self.logoImgView != nil) else {
            return
        }
        
        self.logoImgView.image = UIImage.init(named: "App-share-Icon")
        self.logoImgView.layer.cornerRadius = 8
        self.logoImgView.layer.masksToBounds = true
        self.appNameLbl.text = kiTalker
        self.versionLbl.text = "v" + KAppVersion
        if #available(iOS 13.0, *) {
            self.versionLbl.textColor = UIColor.secondaryLabel
        }
        self.contentLbl.text = kAppAbout
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date.init())
        self.copylightLbl.text = "Copyright © 2018-" + yearString + " iHTCboy"
        
        #if targetEnvironment(macCatalyst)
            self.logoImgView.layer.cornerRadius = logoImgView.frame.size.width / 3.5
            self.appNameLbl.text = kiTalker + " for macOS"
            self.contentLbl.font = UIFont.systemFont(ofSize: 25)
        #endif
    }
}


