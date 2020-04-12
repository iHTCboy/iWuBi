//
//  IHTC86WordViewController.swift
//  iWuBi
//
//  Created by HTC on 2017/4/8.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class IHTC86WordViewController: ITBasePushTransitionVC {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置默认主题
        let IHTCUD = IHTCUserDefaults.shared
        IHTCUD.setDefaultAppAppearance(style: IHTCUD.getAppAppearance())
        
        // 设置 UI 界面
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        launchAnimate()
        self.tabBarController?.tabBar.tintColor = UIColor(red:0.979, green:0.322, blue:0.000, alpha:1.000)
    }
    
    // MARK:- 懒加载
    fileprivate var titles = IHTCModel.shared.defaultArray
    
    fileprivate lazy var pageTitleView: ITPageTitleView = {
        var titleFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH, width: kScreenW, height: kTitleViewH)
        #if targetEnvironment(macCatalyst)
            titleFrame.origin.y = titleFrame.origin.y + 20
        #endif
        let titleView = ITPageTitleView(frame: titleFrame, titles: self.titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView: ITPageContentView = {[weak self] in
        // 1. 确定内容 frame
        let contentH = kScreenH - kStatusBarH - kNavBarH - kHomeIndcator
        var contentFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH + kTitleViewH, width: kScreenW, height: contentH)
        #if targetEnvironment(macCatalyst)
            contentFrame.origin.y = contentFrame.origin.y + 20
            contentFrame.size.height = contentFrame.size.height + 1024
        #endif
        // 2. 确定所有控制器
        let counts = 0
        var childVcs = [UIViewController]()
        if let counts = self?.titles.count {
            for i in 0..<counts {
                let vc = IHTCWordListViewController()
                vc.title = self?.titles[i]
                childVcs.append(vc)
            }
        }
        
    let contentView = ITPageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
    contentView.delegate = self
    return contentView
    }()
    
    var isFirstLaunch = false
    
    @IBAction func clickedSearchItem(_ sender: Any) {
        let vc = IHTCSearchViewController()
        vc.is86Word = true
        let navi = UINavigationController.init(rootViewController: vc)
        navi.navigationBar.isHidden = true
        self.present(navi, animated: true, completion: nil)
    }
    
}


// MARK:- 设置 UI
extension IHTC86WordViewController {
    fileprivate func setUpUI() {
        #if !targetEnvironment(macCatalyst)
        // 0. 不允许系统调整 scrollview 内边距
        automaticallyAdjustsScrollViewInsets = false
        #endif
        
        // 1. 添加 titleview
        view.addSubview(pageTitleView)
        
        // 2. 添加 contentview
        view.addSubview(pageContentView)
    }
    
    func launchAnimate() {
        if !isFirstLaunch {
            isFirstLaunch = true
            
            let sb = UIStoryboard.init(name: "AppLaunchScreen", bundle: nil);
            let vc = sb.instantiateInitialViewController()!
            if #available(iOS 13.0, *), UIDevice.current.userInterfaceIdiom == .pad {
                vc.view.frame = view.frame //Support iPadOS mutiple windows
            }
            let launchView = vc.view
            var window = view.window
            
            if window == nil {
                 // Support iPadOS mutiple windows, 当前有2个窗口在前台时
                if #available(iOS 13.0, *), UIDevice.current.userInterfaceIdiom == .pad {
                    let scenes = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    
                    scenes.forEach { (scene) in
                        scene.windows.forEach({ (wd) in
                            if wd.isMember(of: UIWindow.self) && wd.frame.equalTo(view.frame) {
                                window = wd
                            }
                        })
                    }
                }
            }
            
            if window == nil {
                window = UIViewController.keyWindowHTC()
            }
            
            window?.addSubview(launchView!)
            
            UIView.animate(withDuration: 0.25, delay: 0.8, options: .beginFromCurrentState, animations: {
                launchView?.layer.transform = CATransform3DScale(CATransform3DIdentity, 2, 2, 1)
                launchView?.alpha = 0.0
            }, completion: { (true) in
                launchView?.removeFromSuperview()
            })
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK:- pageTitleViewDelegate
extension IHTC86WordViewController: ITPageTitleViewDelegate {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int) {
        pageContentView.scrollToIndex(index: index)
        selectTitleIndex = index
    }
}

// MARK:- pageContentViewDelegate
extension IHTC86WordViewController: ITPageContentViewDelegate {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgerss(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        selectTitleIndex = targetIndex
    }
}




