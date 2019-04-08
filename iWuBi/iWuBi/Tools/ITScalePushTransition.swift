//
//  ITScalePushTransion.swift
//  iTalker
//
//  Created by HTC on 2017/4/16.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITScalePushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //1.获取动画的源控制器和目标控制器
        let prentVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ITBasePushTransitionVC
        let fromVC = prentVC.children[prentVC.selectTitleIndex] as! ITQuestionListViewController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ITQuestionDetailViewController
        let container = transitionContext.containerView
        
        //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
        let snapshotView = fromVC.selectedCell.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = container.convert(fromVC.selectedCell.frame, from: fromVC.tableView)
        fromVC.selectedCell.isHidden = true
        
        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVC.tableView.isHidden = true
        
        //4.都添加到 container 中。注意顺序不能错了
        container.addSubview(toVC.view)
        container.addSubview(snapshotView!)
        
        //5.执行动画
        /*
         这时avatarImageView.frame的值只是跟在IB中一样的，
         如果换成屏幕尺寸不同的模拟器运行时avatarImageView会先移动到IB中的frame,动画结束后才会突然变成正确的frame。
         所以需要在动画执行前执行一次toVC.avatarImageView.layoutIfNeeded() update一次frame
         */
        //toVC.selectedCell.layoutIfNeeded()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            snapshotView?.frame = CGRect.init(x: 0, y: 64, width: (snapshotView?.frame.width)!, height: (snapshotView?.frame.height)!)
            toVC.view.alpha = 1
        }) { (finish: Bool) -> Void in
            fromVC.selectedCell.isHidden = false
            toVC.tableView.isHidden = false
            //toVC.selectedCell = toVC.image
            snapshotView?.removeFromSuperview()
            
            //一定要记得动画完成后执行此方法，让系统管理 navigation
            transitionContext.completeTransition(true)
        }
    }
}
