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
        self.title = "关于\(kiTalker)"
        
        guard (self.logoImgView != nil) else {
            return
        }
        
        self.logoImgView.image = UIImage.init(named: "App-share-Icon")
        self.logoImgView.layer.cornerRadius = 8
        self.logoImgView.layer.masksToBounds = true
        self.appNameLbl.text = kiTalker
        self.versionLbl.text = "v" + KAppVersion
        self.contentLbl.text = kAppAbout
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date.init())
        self.copylightLbl.text = "Copyright © 2018-" + yearString + " iHTCboy"
    }
}


