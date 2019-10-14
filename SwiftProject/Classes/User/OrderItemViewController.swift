//
//  OrderItemViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderItemViewController: UIViewController {

    enum OrderItemType:Int {
        case All
        case WaitPay
        case WaitSend
        case Sended
        case Finished
        case Service
    }
    
    var type:OrderItemType = .All
    
    let tableView:UITableView = {
        let t = UITableView(frame: .zero)
        t.separatorStyle = .none
        t.estimatedRowHeight = 300
        t.showsVerticalScrollIndicator = false
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        v.backgroundColor = UIColor.groupTableViewBackground
        t.tableFooterView = v
        return t
    }()
    
    let emptyDataLab = UILabel()
    
    let cellId = "OrderItemCell"
    
    var dataSource = [MOrderVMItem]()
    
    var pageIndex:Int = 1;
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "OrderItemCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        layoutViews()
        
        getData(pageIdx: pageIndex)
    }
    
    func layoutViews(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(emptyDataLab)
        emptyDataLab.text = "没有此类订单~"
        emptyDataLab.textColor = .HBlue
        emptyDataLab.font = UIFont.systemFont(ofSize: 15)
        emptyDataLab.isHidden = true
        emptyDataLab.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
}

extension OrderItemViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderItemCell
        let model = dataSource[indexPath.row]
        cell.order = model.order
        cell.items = model.ProductSnapList
        cell.selectedCell = {[unowned self] in
            self.showDetailOrder(order: model.order.OrderNo)
        }
        cell.btnAction = {[unowned self] (btn) in
            self.dealWith(model:model,title: btn.currentTitle)
        }
        return cell
    }
    
}

extension OrderItemViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let idxPath = IndexPath(row: self.dataSource.count - 1, section: 0)
        if idxPath == indexPath && !isLoadingMore{
            isLoadingMore = true
            getData(pageIdx: pageIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = dataSource[indexPath.row]
        showDetailOrder(order: model.order.OrderNo)
        
    }
    
    func showDetailOrder(order:String){
        let vc = OrderDetailViewController()
        vc.orderNo = order
        show(vc, sender: nil)
    }
    
}


extension OrderItemViewController {
    
    func getData(pageIdx:Int){
        var api:API
        switch type {
        case .All: api = API.GeOrderAll(key: UserHelper.UserKey.getValue!,pageIndex: pageIdx,OrderState: "")
        case .WaitPay: api = API.GeOrderAll(key: UserHelper.UserKey.getValue!,pageIndex: pageIdx,OrderState: "待支付")
        case .WaitSend: api = API.GeOrderAll(key: UserHelper.UserKey.getValue!,pageIndex: pageIdx,OrderState: "待发货")
        case .Sended: api = API.GeOrderAll(key: UserHelper.UserKey.getValue!,pageIndex: pageIdx,OrderState: "已发货")
        case .Finished: api = API.GeOrderAll(key: UserHelper.UserKey.getValue!,pageIndex: pageIdx,OrderState: "已完成")
        case .Service: api = API.GeOrderAllRefund(key: UserHelper.UserKey.getValue!)
        }
        
        HRequest.getData(api: api) { (data) in
            let dataArr = data["MOrderVM"].arrayValue
            
            var modelArr = [MOrderVMItem]()
            for json in dataArr {
                guard let model = MOrderVMItem.deserialize(from: json.rawString()) else{
                    continue
                }
                modelArr.append(model)
            }
            if self.pageIndex == 1{
                self.dataSource.removeAll()
            }
            self.dataSource.append(contentsOf: modelArr)
            self.pageIndex += 1
            if modelArr.count < 10 {
                self.isLoadingMore = true
            }
            self.isLoadingMore = false
            
            self.tableView.reloadData()
            
            if self.dataSource.count == 0 {
                self.emptyDataLab.isHidden = false
                self.view.bringSubviewToFront(self.emptyDataLab)
            }else{
                self.emptyDataLab.isHidden = true
            }
        }
    }
}


extension OrderItemViewController {
    
    func dealWith(model:MOrderVMItem,title:String?){
        
        //联系客服   去支付  确认收货
        if let t = title {
            
            switch t {
            case "联系客服":
                let str = "telprompt://13649426876"
                if let url = URL(string: str) {
                    UIApplication.shared.openURL(url)
                }
            case "申请退款":
                let api = API.ApplyRefund(orderno: model.order.OrderNo)
                HRequest.getData(api: api) { (data) in
                    self.view.toast(message: "申请成功，请等待审核")
                    self.pageIndex = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.getData(pageIdx: self.pageIndex)
                    })
                }
            case "确认收货":
                let api = API.OrderReceiving(orderno: model.order.OrderNo)
                HRequest.getData(api: api) { (data) in
                    self.view.toast(message: "您已确认收货")
                    self.pageIndex = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.getData(pageIdx: self.pageIndex)
                    })
                }
            case "去支付":
                let payVC = PayContainerViewController()
                payVC.payViewController.payParams = (orderNo:model.order.OrderNo,price:model.order.AgentPrice,countPrice:model.order.SumPrice)
                payVC.modalPresentationStyle = .custom
                self.present(payVC, animated: false)
                payVC.payFinishedDismiss = {[unowned self] (orderNo) in
                    //是否支付成功
                    self.pageIndex = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.getData(pageIdx: self.pageIndex)
                    })
                }
            default:
                return
            }
            
            
            
        }
    }
    
}
