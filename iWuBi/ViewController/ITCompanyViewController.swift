//
//  ITCompanyViewController.swift
//  iTalker
//
//  Created by HTC on 2017/4/16.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITCompanyViewController: ITBasePushTransitionVC
{
    
    // MARK: Life Cycle
    override func viewDidLoad() {
    super.viewDidLoad()
        // 设置 UI 界面
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    }
    
    // MARK:- 懒加载
    fileprivate var titles = ILeetCoderModel.shared.enterpriseArray
    
    fileprivate lazy var pageTitleView: ITPageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH, width: kScreenW, height: kTitleViewH)
        let titleView = ITPageTitleView(frame: titleFrame, titles: self.titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView: ITPageContentView = {[weak self] in
        // 1. 确定内容 frame
        let contentH = kScreenH - kStatusBarH - kNavBarH - kHomeIndcator
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH + kTitleViewH, width: kScreenW, height: contentH)
        // 2. 确定所有控制器
        let counts = 0
        var childVcs = [UIViewController]()
        if let counts = self?.titles.count {
        for i in 0..<counts {
            let vc = ITQuestionListViewController()
            vc.title = self?.titles[i]
            childVcs.append(vc)
        }
    }
    
    let contentView = ITPageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        contentView.delegate = self
        return contentView
    }()

}
    
// MARK:- 设置 UI
extension ITCompanyViewController {
    fileprivate func setUpUI() {
        // 0. 不允许系统调整 scrollview 内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1. 添加 titleview
        view.addSubview(pageTitleView)
        
        // 2. 添加 contentview
        view.addSubview(pageContentView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK:- pageTitleViewDelegate
extension ITCompanyViewController: ITPageTitleViewDelegate {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int) {
        pageContentView.scrollToIndex(index: index)
        self.selectTitleIndex = index
    }
}

// MARK:- pageContentViewDelegate
extension ITCompanyViewController: ITPageContentViewDelegate {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgerss(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        self.selectTitleIndex = targetIndex
    }
}
