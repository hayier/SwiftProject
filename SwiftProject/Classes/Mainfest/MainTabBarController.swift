//
//  MainTabBarController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imgs = ["tab_home","tab_classification","tab_shopping","tab_mine"]
        
        let home = HomeViewController()
        let cate = CategoryViewController()
        let shop = ShopCartViewController()
        let user = UIStoryboard(name:"User", bundle: nil).instantiateInitialViewController()!
        let vcs = [home,cate,shop,user]
        let titles = ["首页","分类","购物车","个人"]
        
        for (idx,img) in imgs.enumerated() {
            addVC(child:vcs[idx],title: titles[idx], normalImg: img, selectedImg: img + "_hove")
        }
        
        tabBar.tintColor = .HBlue
    }
    
    func addVC(child vc:UIViewController,title:String,normalImg:String,selectedImg:String){
        
        let nav = MainNavigationController(rootViewController: vc)
        addChild(nav)
        vc.tabBarItem.image = UIImage(named: normalImg)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImg) //?.withRenderingMode(.alwaysOriginal)
        vc.title = title
    }

}


