//
//  MainNavigationController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        if viewControllers.count == 1{
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        vc.navigationItem.backBarButtonItem = item
        if viewControllers.count == 1{
            vc.hidesBottomBarWhenPushed = true
        }
        super.show(vc, sender: sender)
    }
    
    

}
