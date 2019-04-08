//
//  ITBasePopTransitionVC.swift
//  iTalker
//
//  Created by HTC on 2017/4/16.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITBasePopTransitionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
        
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.edgePanGesture(_:)))
        edgePan.edges = UIRectEdge.left
        self.view.addGestureRecognizer(edgePan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
}


extension ITBasePopTransitionVC {
    @objc func edgePanGesture(_ edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translation(in: self.view).x / self.view.bounds.width
        
        if edgePan.state == UIGestureRecognizer.State.began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewController(animated: true)
        } else if edgePan.state == UIGestureRecognizer.State.changed {
            self.percentDrivenTransition?.update(progress)
        } else if edgePan.state == UIGestureRecognizer.State.cancelled || edgePan.state == UIGestureRecognizer.State.ended {
            if progress > 0.3 {
                self.percentDrivenTransition?.finish()
            } else {
                self.percentDrivenTransition?.cancel()
            }
            self.percentDrivenTransition = nil
        }
    }
}


extension ITBasePopTransitionVC : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationController.Operation.pop {
            return ITScalePopTransition()
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is ITScalePopTransition {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
}

