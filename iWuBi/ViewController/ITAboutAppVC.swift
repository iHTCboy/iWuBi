//
//  ITAboutAppVC.swift
//  iTalker
//
//  Created by HTC on 2017/4/23.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITAboutAppVC: UIViewController {

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

extension ITAboutAppVC
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
        self.contentLbl.text = "\(kiTalker) 为一款IT工程师们提供算法知识充电的应用，IT算法和数据结构知识学习、面试必备的工具，不断努力打造更多更好方式呈现更有趣的知识，让大家在零碎时间也可以快速和简单的学习get! \n \n 1、1000+题库，满足你对算法求知欲望！\n2、IT企业面试题目，为你完名企的梦！\n3、最全算法知识，为你准备好的面试！"
        self.copylightLbl.text = "Copyright © 2019 " + "iHTCboy"
    }
}


