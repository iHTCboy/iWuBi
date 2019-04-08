//
//  ITPageTitleView.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

// MARK:- 定义ITPageTitleView常量
fileprivate let kScroLineH: CGFloat = 2
fileprivate let kTitleMargin: CGFloat = 20
fileprivate let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
fileprivate let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// MARK:- 定义协议
protocol ITPageTitleViewDelegate: class {
    func pageTitleView(pageTitleView: ITPageTitleView, didSelectedIndex index: Int)
}

class ITPageTitleView: UIView {
    
    // MARK:- 定义属性
    fileprivate var titles: [String]
    fileprivate var currentIndex: Int = 0
    weak var delegate:ITPageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = true
        return scrollView
    }()
    
    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 设置 UI 界面
extension ITPageTitleView {
    fileprivate func setUpUI() {
        // 1. 添加 scrollview
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加 title 对应的 label
        setUpTitleLabels()
        
        // 3. 设置底部滚动条
        setUpBottomLineAndScroLine()
    }
    
    fileprivate func setUpTitleLabels() {
        // 先确定 label 的一些 frame 值
        var labelX: CGFloat = 0
        let labelH: CGFloat = frame.height - kScroLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            let textNS = title as NSString
            let labelRect:CGRect = textNS.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font as Any], context: nil)
            let labelW = labelRect.width + kTitleMargin
            
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            labelX += labelW
            scrollView.contentSize = CGSize.init(width: labelX, height: labelH)
            
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 添加手势识别
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
        
        if scrollView.contentSize.width < scrollView.frame.width {
            scrollView.frame = CGRect.init(x: 0, y: 0, width: scrollView.contentSize.width, height: frame.height)
        }
    }
    
    fileprivate func setUpBottomLineAndScroLine() {
        // 1. 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2. 添加 scrollLine
        guard let firstLabel = titleLabels.first else { return }
        
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x + kTitleMargin/2, y: frame.height - kScroLineH, width: firstLabel.frame.width-kTitleMargin, height: kScroLineH)
    }
    
    fileprivate func scrollToMiddle(targetLabel: UILabel) {
        
        let targetMinX = targetLabel.frame.minX
        let targetW = targetLabel.frame.width
        let W2 = self.scrollView.frame.size.width/2;
        let contentOffset = self.scrollView.contentOffset.x
        
        // 2.1
        if ((targetMinX+W2+targetW/2) > self.scrollView.contentSize.width) {
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.contentSize.width - W2*2, y: 0), animated: true)
        }else if((targetMinX+contentOffset) > W2){
            self.scrollView.setContentOffset(CGPoint.init(x: targetMinX - W2 + targetW/2, y: 0), animated: true)
        }else if (contentOffset>0 && targetMinX<W2){
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}

// MARK:- 事件监听
extension ITPageTitleView {
    /// titleLabel 点击
    @objc fileprivate func titleLabelClick(tapGes: UITapGestureRecognizer) {
        // 1. 获得点击的下标
        guard let view = tapGes.view else { return }
        let index = view.tag
        
        // 如果重复点击当前标题, 不用滚动
        if currentIndex == index {
            return
        }
        
        // 2. 滚动到对应位置
        scrollToIndex(index: index)
        
        // 3. 通知代理
        delegate?.pageTitleView(pageTitleView: self, didSelectedIndex: index)
    }
    
    fileprivate func scrollToIndex(index: Int) {
        // 1. 获取之前的 label 和最新的 label
        let targetLabel = titleLabels[index]
        let oldLabel = titleLabels[currentIndex]
        
        // 2. 设置 label 颜色
        targetLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 3. scrollLIne 滚动到对应位置
        let scrollLineEndX = targetLabel.frame.origin.x + kTitleMargin/2
        let scrollLineW = targetLabel.frame.size.width - kTitleMargin
        
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineEndX
            self.scrollLine.frame.size.width = scrollLineW
        }
        
        // 3.1
        scrollToMiddle(targetLabel: targetLabel);
        
        // 4. 记录当前 index
        currentIndex = index
    }
}

// MARK:- 对外暴露方法
extension ITPageTitleView {
    /// 设置当前标题颜色
    func setTitleWithProgerss(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        
        // 1. 取出两个 label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2. 移动 scrollLine
        let moveMargin = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let stW = targetLabel.frame.size.width - sourceLabel.frame.size.width
        let progressW = sourceLabel.frame.size.width + stW * progress - kTitleMargin
        
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + kTitleMargin/2 + moveMargin * progress
        scrollLine.frame.size.width = progressW
        
        // 2.1
        scrollToMiddle(targetLabel: targetLabel);
        
        // 3. 颜色渐变
        // 3.1 取出变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2 变化 sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.3 变化 targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4. 记录最新的 index
        currentIndex = targetIndex
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}

