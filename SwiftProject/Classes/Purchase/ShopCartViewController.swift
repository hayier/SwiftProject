//
//  ShopCartViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/6.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ShopCartViewController: UIViewController {

    var selectedCount:Int = 0
    
    let tableView:UITableView = {
        let t = UITableView()
        t.allowsSelection = false
        t.separatorColor = UIColor.groupTableViewBackground
        t.separatorInset = .zero
        t.rowHeight = 110
        t.tableFooterView = UIView()
        return t
    }()
    
    let emptyBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("购物车是空的，去购物吧！", for: .normal)
        btn.setTitleColor(UIColor.HBlue, for: .normal)
        return btn
    }()
    
    let cellId = "CartCell"
    
    let bottomView = ShopCartBottomView()
    
    var dataSource:[CartDataItem] = [CartDataItem]()
    
    var entryTimes:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "购物车"
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"CartCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        emptyBtn.addTarget(self, action: #selector(goShopping), for: .touchUpInside)
        
        layoutViews()
        
        //getData()
        
        bottomView.allBtn.addTarget(self, action: #selector(selectedAll), for: .touchUpInside)
        bottomView.countBtn.addTarget(self, action: #selector(countBill), for: .touchUpInside)
        bottomView.allBtn.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveItemNotificationPost), name: NSNotification.Name(CartCell.notificationNameItemChanged), object: nil)
        
        
    }
    
    func layoutViews(){
        
        view.addSubview(bottomView)
        
        view.addSubview(tableView)
        
        view.addSubview(emptyBtn)
    
        bottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        tableView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
            if #available(iOS 11.0, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(topLayoutGuide.snp.top)
            }
        }
        
        emptyBtn.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    @objc func receiveItemNotificationPost(noti:Notification){
        let cell = noti.object as! CartCell
        let view = noti.userInfo!["view"] as! UIView
        if view == cell.selectBtn {
            let type = cell.selectBtn.isSelected ? CheckType.checked : CheckType.unchecked
            checkItem(id: cell.model!.ID, type:type, groupid: cell.model!.GroupID)
        }else{
            editItemNum(key: UserHelper.UserKey.getValue!, ProductID: cell.model!.GoodsID, GetCnt: cell.model!.GetCnt, GroupID: cell.model!.GroupID)
        }

        //更新data
        if let row = tableView.indexPath(for: cell)?.row{
            dataSource[row] = cell.model!
            //计算
            caculate()
        }
    }
    
    func caculate(){
        var count:Int = 0
        var price:Float = 0
        var isSelected:Bool = true
        for i in dataSource {
            
            if(i.IsCheck){
                count += i.GetCnt
                price += i.attr_price * Float(i.GetCnt)
            }
            
            if(!i.IsCheck){
                isSelected = false
            }
        }
        bottomView.countBtn.setTitle("结算(\(count))", for: .normal)
        bottomView.priceLab.text = String(format: "%.2f", price)
        bottomView.allBtn.isSelected = isSelected
    }
    
    @objc func selectedAll(){
        bottomView.allBtn.isSelected = !bottomView.allBtn.isSelected
        var d = [CartDataItem]()
        for i in dataSource{
            //struct  需要通过值转换
            var t = i
            t.IsCheck = bottomView.allBtn.isSelected
            d.append(t)
            let type = t.IsCheck ? CheckType.checked : CheckType.unchecked
            checkItem(id: t.ID, type: type, groupid: t.GroupID)
        }
        dataSource = d
        caculate()
        tableView.reloadData()
    }
    
    
    func emptyDataSet(){
        
        if dataSource.count == 0 {
            emptyBtn.isHidden = false
            view.bringSubviewToFront(emptyBtn)
            bottomView.allBtn.isHidden = true
        }else{
            emptyBtn.isHidden = true
            bottomView.allBtn.isHidden = false
        }
    }
    
    @objc func goShopping(){
        guard let tabbarVC = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else{
            return
        }
        tabbarVC.selectedIndex = 0
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ShopCartViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
             self.getData()
        }
        entryTimes += 1
    }
}

extension ShopCartViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CartCell
        cell.model = dataSource[indexPath.row]
        return cell
    }

}

extension ShopCartViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //只做删除
        let item = dataSource[indexPath.row]
        deleteItem(key: UserHelper.UserKey.getValue!, id: "\(item.ID)",idx: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}


extension ShopCartViewController{
    
    func getData(){
        
        guard let key = UserHelper.UserKey.getValue else {
            //未登录
            if entryTimes == 0 {
                UserHelper.showLogin()
            }
            return
        }
   
        let api = API.GetCart(key: key)
        
        HRequest.getData(api: api) {
            self.dataSource.removeAll()
            for item in $0.arrayValue{
                guard var data = CartDataItem.deserialize(from: item.rawString()) else{
                    break
                }
                if data.GroupID == 0{
                    data.attr_price = data.Price
                }
                self.dataSource.append(data)
            }
            self.tableView.reloadData()
            self.caculate()
            
            self.emptyDataSet()
        }
        
    }
    
    //选中状态
    func checkItem(id:Int,type:CheckType,groupid:Int){
     
        let api = API.CheckByID(id: id, type: type, groupid: groupid)
        
        HRequest.getData(api: api) { (_) in
            print("check_ok")
        }
        
    }
    
    //修改数量
    func editItemNum(key: String, ProductID: Int, GetCnt: Int, GroupID: Int){
        let api = API.EditFromCart(key: key, ProductID: ProductID, GetCnt: GetCnt, GroupID: GroupID)
        HRequest.getData(api: api){ (_) in
            print("edit_ok")
        }
    }
    
    //删除item
    func deleteItem(key:String,id:String,idx:Int){
        let api = API.CartBatchRemove(key: key, id: id)
        HRequest.getData(api: api) { (_) in
            self.dataSource.remove(at: idx)
            let indexPath = IndexPath(row: idx, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.caculate()
        }
    }
    
    @objc func countBill(){
        
        guard let _ = UserHelper.UserKey.getValue else {
            //未登录
            UserHelper.showLogin()
            return
        }
        
        let items = dataSource.filter{$0.IsCheck}
        if items.count == 0 {
            self.view.toast(message: "请选择您需要购买的产品")
            return
        }
        
        let vc = OrderConfirmViewController()
        vc.buyType = .cart
        vc.cartParams = items
        show(vc, sender: nil)
    }
    
}
