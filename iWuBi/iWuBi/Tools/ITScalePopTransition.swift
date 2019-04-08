//
//  ITScalePopTransion.swift
//  iTalker
//
//  Created by HTC on 2017/4/16.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITScalePopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ITQuestionDetailViewController
        let prentVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ITBasePushTransitionVC
        let toVC = prentVC.children[prentVC.selectTitleIndex] as! ITQuestionListViewController
        let container = transitionContext.containerView
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ITQuestionDetailViewController
            let prentVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ITBasePushTransitionVC
            let toVC = prentVC.children[prentVC.selectTitleIndex] as! ITQuestionListViewController
            let container = transitionContext.containerView
            
            let snapshotView = fromVC.selectedCell.snapshotView(afterScreenUpdates: false)
            snapshotView?.frame = container.convert(fromVC.selectedCell.frame, from: fromVC.view)
            fromVC.selectedCell.isHidden = true
            
            prentVC.view.frame = transitionContext.finalFrame(for: prentVC)
            toVC.selectedCell.isHidden = true
            
            container.insertSubview(prentVC.view, belowSubview: fromVC.tableView)
            container.addSubview(snapshotView!)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
                snapshotView?.frame = container.convert(toVC.selectedCell.frame, from: toVC.tableView)
                fromVC.view.alpha = 0
            }) { (finish: Bool) -> Void in
                toVC.selectedCell.isHidden = false
                snapshotView?.removeFromSuperview()
                fromVC.selectedCell.isHidden = false
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

        let snapshotView = fromVC.selectedCell.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = container.convert(fromVC.selectedCell.frame, from: fromVC.tableView)
        fromVC.selectedCell.isHidden = true
        
        prentVC.view.frame = transitionContext.finalFrame(for: prentVC)
        //toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.selectedCell.isHidden = true
        
        container.insertSubview(prentVC.view, belowSubview: fromVC.view)
        //container.insertSubview(toVC.view, belowSubview: fromVC.view)
        container.addSubview(snapshotView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            snapshotView?.frame = container.convert(toVC.selectedCell.frame, from: toVC.tableView)
            fromVC.view.alpha = 0
        }) { (finish: Bool) -> Void in
            toVC.selectedCell.isHidden = false
            snapshotView?.removeFromSuperview()
            fromVC.selectedCell.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}
