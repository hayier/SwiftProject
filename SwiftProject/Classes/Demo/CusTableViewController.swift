//
//  CusTableViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/25.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit




class CusTableViewController:UIViewController {

    var dataSource = [Any]()
    
    let tableView:UITableView = {
        let t = UITableView()
        return t
    }()
    
    var cellType:AnyClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let cellId = String(describing: type(of: cellType))
        tableView.register(cellType, forCellReuseIdentifier: cellId)
    }
    

    func layoutViews(){
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
    
}


class Dog{
    class func createDog(type:Int) -> Dog{
        if(type == 0){
            return BigDog()
        }else{
            return LittleDog()
        }
    }
    func love(){
        
    }
}

class BigDog: Dog {
    override func love() {
        print(NSStringFromClass(type(of: self)) + "love to fight")
    }
}

class LittleDog: Dog {
    override func love() {
        print(NSStringFromClass(type(of: self)) + "love to play")
    }
}
