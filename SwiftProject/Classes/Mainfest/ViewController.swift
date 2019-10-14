//
//  ViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/4/30.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func btnClick(_ sender: UIButton) {
        let sb = UIStoryboard(name: "User", bundle: nil)
        switch sender.currentTitle {
        case "个人":
            let vc = sb.instantiateViewController(withIdentifier: "UserTableViewController")
            show(vc, sender: nil)
        case "订单":
            let vc = OrderViewController()
            show(vc, sender: nil)
        case "购物车":
            let vc = ShopCartViewController()
            show(vc, sender: nil)
        case "收货地址":
            let vc = AddressListViewController()
            show(vc, sender: nil)
        case "首页":
            let vc = HomeViewController()
            show(vc, sender: nil)
        case "产品详情":
            let vc = ProductDetailViewController()
            show(vc, sender: nil)
        case "分类":
            let vc = CategoryViewController()
            show(vc, sender: nil)
        default:
            break
        }
        
    }
    
}

