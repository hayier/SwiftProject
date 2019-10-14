
//
//  OrderConfirmViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/30.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderConfirmViewController: UIViewController {
    
    let tableView:UITableView = {
        let t = UITableView()
        t.backgroundColor = UIColor.groupTableViewBackground
        t.separatorStyle = .none
        t.rowHeight = 120
        t.showsVerticalScrollIndicator = false
        return t
    }()
    
    let bottomView = OrderComfirmBottomView()
    
    //let payVC = PayViewController()
    
    let cellId = "OrderItemProductCell"
    //单个购买参数
    var mailParams:(productCnt:Int,Group:ProductAttrGroupItem,Value:ProductAttrValueItem,product:Product)?
    //购物车购买参数
    var cartParams:[CartDataItem]?
    
    var buyType:BuyType = BuyType.mail
    
    let footerView = Bundle.main.loadNibNamed("OrderComfirmFooter", owner: self, options: nil)?.first as! OrderComfirmFooter
    
    var productItems = [GoodsVMsItem]()
    
    var mail:Address?{
        didSet{
            createAddress()
        }
    }
    
    var countPrice:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订单确认"
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OrderItemProductCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        layoutViews()
        
        getData()
        
//        addChild(payVC)
//        view.addSubview(payVC.view)
//        payVC.view.isHidden = true
        
        bottomView.sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(editAddress), name: NSNotification.Name(rawValue: "com.Address.edit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectnewAddress), name: NSNotification.Name(rawValue: "com.address.selectNew"), object: nil)
    }
    
    func layoutViews(){
        view.addSubview(tableView)
        
        view.addSubview(bottomView)
        
        tableView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            if UIApplication.shared.statusBarFrame.height > 30 {
                $0.height.equalTo(65)
            }else{
                $0.height.equalTo(45)
            }
        }
    }
    
    func createAddress(){
        guard let address = mail else{
            //使用例外一个view
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
            btn.setImage(UIImage(named: "address_icon1"), for: .normal)
            btn.setTitle("新建收货地址", for: .normal)
            btn.setTitleColor(.HTextBlack, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btn.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            tableView.tableHeaderView = btn
            return
        }
        let addressView = OrderAddressView(frame: CGRect(x: 0, y: 0, width: 100, height: 90))
        addressView.cell?.nameLab.text = address.ContactName
        addressView.cell?.phoneLab.text = address.ContactMobile
        let name = AddressModel.getCitiesName(pID: address.ProvinceID, cID: address.CityID, tID: address.AreaID)
        addressView.cell?.addressLab.text = name.p + name.c + name.t + address.Address
        addressView.cell?.editBtn.isHidden = true
        
        tableView.tableHeaderView = addressView
    }
    
    func caculeteFooter(){
        
        var p_price:Float = 0
        var ex_price:Float = 0
        let _ = productItems.map{
            
            if let p = $0.product{
                if let value = $0.mAttrValue {
                    p_price += value.Price * Float($0.cnt)
                }else{
                    p_price += p.Price * Float($0.cnt)
                }
                 ex_price += p.Freight
            }
        }
        let or_price = p_price + ex_price
        
        countPrice = or_price
        
        footerView.p_priceLab.text = String(format: "￥%.2f", p_price)
        footerView.ep_priceLab.text = String(format: "￥%.2f", ex_price)
        footerView.od_priceLab.text = String(format: "￥%.2f", or_price)
        
        footerView.count_priceLab.text = String(format: "￥%.2f", or_price)
        
        bottomView.countLab.text = String(format: "需付款:￥%.2f", or_price)
        
        tableView.tableFooterView = footerView
    }
    
    //    @objc func editAddress(){
    //        let vc = AddAdsViewController()
    //        vc.mail = self.mail
    //        show(vc, sender: nil)
    //    }
    
    @objc func addAddress(){
        let vc = AddAdsViewController()
        vc.success = {[unowned self] in
            self.getData();
        }
        show(vc, sender: nil)
    }
    
    @objc func selectnewAddress(){
        let vc = AddressListViewController()
        vc.selectedAddress = { (address) in
            self.mail = address
        }
        show(vc, sender: nil)
    }
    
    @objc func sureAction(){
        createOrder()
    }
    
    func pay(order:String,price:Float){
        
        let payVC = PayContainerViewController()
        payVC.payViewController.payParams = (orderNo:order,price:price,countPrice:countPrice)
        payVC.modalPresentationStyle = .custom
        self.present(payVC, animated: false) {
            //payVC.payViewController.showView()
        }
        payVC.payFinishedDismiss = {[unowned self] (orderNo) in
            guard let vcs = self.navigationController?.viewControllers else{
                return
            }
            let vc = OrderDetailViewController()
            vc.orderNo = orderNo
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.viewControllers = [vcs.first!,vc]
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension OrderConfirmViewController:UITableViewDelegate{
    
    
    
}

extension OrderConfirmViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderItemProductCell
        let item = productItems[indexPath.row]
        var model:(s:String,p:Float,c:Int,n:String,i:String)
        if let value = item.mAttrValue {
            model = (s:value.AttrValue!,p:value.Price,c:item.cnt,n:item.product.ProductName,i:value.StgPic!)
        }else{
             model = (s:item.product.ProductDetiles,p:item.product.Price,c:item.cnt,n:item.product.ProductName,i:item.product.ProductImg)
        }
        cell.standardsLab.text = "规格:" + model.s
        cell.priceLab.text = String(format: "￥%.2f", model.p)
        cell.countLab.text = "x\(model.c)"
        cell.nameLab.text = model.n
        cell.imgv.kf.setImage(with: model.i.imgRequestUrl)
        return cell
    }
    
    
}


extension OrderConfirmViewController{
    
    func getData(){
        
        var api:API
        
        if buyType == .cart {
            guard let params = cartParams else {
                return
            }
            var ids:String = ""
            let _ = params.map{
                ids += "\($0.ID),"
            }
            ids.removeLast()
            api = API.PlaceOrder(key: UserHelper.UserKey.getValue!,mpk: "0", cartids: ids, type: buyType, addressId: 0, cnt: 0, groupid:0)
        }else{
            guard let params = mailParams else {
                return
            }
            let mpk = "\(params.Value.ProductID)"
            api = API.PlaceOrder(key: UserHelper.UserKey.getValue!,mpk: mpk, cartids: "0", type: .mail, addressId: 0, cnt: params.productCnt, groupid: params.Group.ID)
        }
      
        HRequest.getData(api: api){
            
            let goods = $0["goodsVMs"].arrayValue
            var items = [GoodsVMsItem]()
            for g in goods {
                guard let model = GoodsVMsItem.deserialize(from: g.rawString()) else{
                    break
                }
                items.append(model)
            }
            
            self.mail = Address.deserialize(from:$0["C_UserMail"].rawString())
            self.productItems = items
            self.caculeteFooter()
            
            self.tableView.reloadData()
        }
        
    }
    
    
    func createOrder(){
        
        guard let mail = self.mail else {
            self.view.toast(message: "请先选择收货地址")
            return
        }
   
        var api:API
        if buyType == .mail{
            
            guard let product = self.productItems.first else {
                return
            }
            
            guard let ProductID = product.product?.ProductID else{
                return
            }
            
            var GroupID:Int = 0
            if let value = product.mAttrValue{
                GroupID = value.ID
            }else{
                GroupID = product.product!.GroupID
            }
            
            api = API.OrderCreate(key: UserHelper.UserKey.getValue!,mpk:"\(ProductID)", mailpk: "\(mail.ID)", cartpks: "0", type: .mail, mcnt: product.cnt, groupids: "\(GroupID)", Remark: self.footerView.markTf.text ?? "无留言",mode: "0")
            
            HRequest.getData(api: api) { (data) in
                let orderNo = data["orderno"].stringValue
                let agentprice = data["agentprice"].floatValue
                self.pay(order: orderNo,price: agentprice)
            }
        }else{
            
            guard let params = cartParams else{
                return
            }
            
            var cartIds = ""
            for p in params {
                cartIds += "\(p.ID),"
            }
            cartIds.removeLast()
            
            api = API.OrderCreate(key: UserHelper.UserKey.getValue!,mpk:"", mailpk: "\(mail.ID)", cartpks: cartIds, type: .cart, mcnt: 0, groupids: "", Remark: self.footerView.markTf.text ?? "无留言",mode: "wx")
        }
        
        HRequest.getData(api: api) { (data) in
            let orderNo = data["orderno"].stringValue
            let agentprice = data["agentprice"].floatValue
            self.pay(order: orderNo,price:agentprice)
        }
    }
}
