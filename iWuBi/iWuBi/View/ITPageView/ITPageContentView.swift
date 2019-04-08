//
//  ITPageContentView.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

// MARK:- 定义唯一标识
fileprivate let ITContentCellID = "ITContentCellID"

// MARK:- 定义协议
protocol ITPageContentViewDelegate: class {
    func pageContentView(pageContentView: ITPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class ITPageContentView: UIView {
    
    // MARK:- 定义属性
    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parentVc: UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    weak var delegate: ITPageContentViewDelegate?
    fileprivate var isForbidScrollDelegate: Bool = false
    
    
    // MARK:- 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        // 1. 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2. 创建 collectionView
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ITContentCellID)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
        }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        // 设置 UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置 UI 界面
extension ITPageContentView {
    fileprivate func setUpUI() {
        // 1. 将所有子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc?.addChild(childVc)
        }
        
        // 2. 添加 collectionview, 用于显示信息
        addSubview(collectionView)
        collectionView.frame = bounds
//        if #available(iOS 11.0, *) , DeviceType.IS_IPHONE_X_S {
//            collectionView.contentInset = UIEdgeInsetsMake(kTitleViewH + kStatusBarH, 0, kHomeIndcator, 0)
//        }
    }
}

// MARK:- UICollectionViewDataSource
extension ITPageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. 创建 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITContentCellID, for: indexPath)
        
        // 2. 设置 cell 数据
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension ITPageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0. 判断是否是点击
        if isForbidScrollDelegate { return }
        
        // 1. 定义要获取的内容
        var sourceIndex = 0
        var targetIndex = 0
        var progress: CGFloat = 0
        
        // 2. 获取进度
        let offsetX = scrollView.contentOffset.x
        let ratio = offsetX / scrollView.bounds.width
        progress = ratio - floor(ratio)
        
        // 3. 判断滑动的方向
        if offsetX > startOffsetX {     // 向左滑动
            sourceIndex = Int(offsetX / scrollView.bounds.width)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            if offsetX - startOffsetX == scrollView.bounds.width || progress == 0{
                progress = 1.0
                targetIndex = sourceIndex
            }
        } else  {                       // 向右滑动
            targetIndex = Int(offsetX / scrollView.bounds.width)
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
            progress = 1 - progress
        }
        
        // 4. 通知代理
        delegate?.pageContentView(pageContentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK:- 对外暴露方法
extension ITPageContentView {
    func scrollToIndex(index: Int) {
        // 1. 记录需要执行的代理方法
        isForbidScrollDelegate = true
        
        // 2. 滚到对应位置
        let offsetX = CGPoint(x: CGFloat(index) * collectionView.bounds.width, y: 0)
        collectionView.setContentOffset(offsetX, animated: false)
    }
}



