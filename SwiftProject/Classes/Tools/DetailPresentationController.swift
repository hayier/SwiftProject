//
//  DetaiPresentationController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class DetailPresentationController: UIPresentationController {

    var backView:UIView?
    var contentHeight:CGFloat = 0
    
    static let NotificationNameBackTap = "com.post.present"
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        backView = UIView(frame: UIScreen.main.bounds)
        backView?.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendnoti))
        backView?.addGestureRecognizer(tap)
    }
    
    @objc func sendnoti(){
        NotificationCenter.default.post(name: NSNotification.Name(DetailPresentationController.NotificationNameBackTap), object: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect{
        var f = UIScreen.main.bounds
        f.size.height = self.contentHeight
        return f
    }

    
    override func presentationTransitionWillBegin() {
        backView?.alpha = 0
        containerView?.addSubview(backView!)
        UIView.animate(withDuration: 0.25) {
            self.backView?.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        containerView?.addSubview(backView!)
        UIView.animate(withDuration: 0.25) {
            self.backView?.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
           backView?.removeFromSuperview()
        }
    }
    
    
}
