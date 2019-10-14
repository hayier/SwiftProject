//
//  OrderViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import WMPageController

let navBarFigureMaxY = UIApplication.shared.statusBarFrame.size.height + 44

class OrderViewController: WMPageController {
    
    var idx:Int = 0{
        didSet{
            selectIndex = Int32(idx)
        }
    }
    
    override func viewDidLoad() {
        //初始化界面参数
    
        super.viewDidLoad()
        
        title = "我的订单"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}


//MARK: 实现数据源方法
extension OrderViewController{
    
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return 5
    }
    
    override func numbersOfTitles(in menu: WMMenuView!) -> Int {
        return 5
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return ["全部","待付款","待发货","待收货","已完成"][index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        let vc = OrderItemViewController()
        vc.type = OrderItemViewController.OrderItemType(rawValue: index) ?? .All
        return vc
    }
}

//frame layout
extension OrderViewController{
    
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        let y = navBarFigureMaxY + 50
        return CGRect(x: 0, y: y, width: self.view.frame.size.width, height: self.view.frame.size.height - y)
    }
    
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        let y = navBarFigureMaxY
        return CGRect(x: 0, y: y, width: view.frame.size.width, height: 50)
    }
}

//代理方法控制逻辑
extension OrderViewController{
   
    override func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable : Any]) {
        guard let index = info["index"] as? Int else{
            return
        }
        if index == 0 {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }else{
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
}
