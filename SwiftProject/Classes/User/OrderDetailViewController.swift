//
//  OrderDetailViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/17.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SafariServices

class OrderDetailViewController: UIViewController {

    var orderNo:String?
    
    var mail:Address?
    var order:Order?
    var ProSnapLst = [ProductSnapListItem]()
    var postInfo:PostInfo?
    
    let tableView:UITableView = {
        let t = UITableView()
        t.backgroundColor = UIColor.groupTableViewBackground
        t.separatorStyle = .none
        t.rowHeight = 110
        t.showsVerticalScrollIndicator = false
        return t
    }()
    
    let cellId = "OrderItemProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "订单详情"
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
     
        tableView.register(UINib(nibName: "OrderItemProductCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        
        
        tableView.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            
            $0.left.right.bottom.equalToSuperview()
        }
        
        UIView.show(message: "加载订单...")
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.getData()
        }
        
    }
    
    func createHeader(){
        
        let header = Bundle.main.loadNibNamed("OrderDetailHeaderView", owner: self, options: nil)?.first as!       OrderDetailHeaderView
        
        header.frame = CGRect(x: 0, y: 0, width: 100, height: 230)
        
        header.stateLab.text = self.order?.OrderState
        header.stateDesLab.text = ""
        header.dateLab.text = self.order?.DatPay.dateTtransform()
        header.ad_nameLab.text = self.order?.OrderMan
        header.ad_phoneLab.text = self.order?.OrderMobile
        header.ad_detailLab.text = self.order?.Address
        
        tableView.tableHeaderView = header
    }
    
    func createFooter(){
        
        let footer = OrderDetailFooterView(frame: CGRect(x: 0, y: 0, width: 100, height: 450))
        
        var expressPrice:Float = 0
        var productPrice:Float = 0
        for product in self.ProSnapLst {
            expressPrice += product.Freight
            productPrice += product.BuyPrice
        }
        
        //商品总价
        footer.countFooterView.p_priceLab.text = String(format: "￥%.2f",productPrice)
        //运费
        footer.countFooterView.ep_priceLab.text = String(format: "￥%.2f",expressPrice)
        //订单总价
        footer.countFooterView.od_priceLab.text = String(format: "￥%.2f",self.order!.SumPrice)
        //需付金额
        footer.countFooterView.count_priceLab.text = String(format: "￥%.2f",self.order!.PayPrice)
        
        if self.order?.PayType.count == 0{
            footer.countFooterView.payPriceDescLab.text = "需付款"
        }else{
            footer.countFooterView.payPriceDescLab.text = "实付款"
        }
        
        footer.countFooterView.markTf.isEnabled = false
        if self.order?.Remark.count == 0 {
            footer.countFooterView.markTf.text = "无"
        }else{
            footer.countFooterView.markTf.text = self.order?.Remark
        }
       
        //===========
        footer.infoFooterView.orderNoLab.text = self.order?.OrderNo
        footer.infoFooterView.stateLab.text = self.order?.OrderState
        if self.order?.PayType.count == 0 {
            footer.infoFooterView.paywayLab.text = "未付款"
        }else{
            footer.infoFooterView.paywayLab.text = self.order?.PayType
        }
        
        footer.infoFooterView.payMoneyLab.text = String(format: "￥%.2f",self.order!.PayPrice)
        footer.infoFooterView.payDateLab.text = self.order?.DatPay.dateTtransform()
        
        if self.order?.OrderState == "待支付"{
            footer.dealBtn.setTitle("去支付", for: .normal)
        }else if self.order?.OrderState == "已发货"{
            footer.dealBtn.setTitle("查看物流", for: .normal)
        }else{
            footer.dealBtn.setTitle("联系客服", for: .normal)
        }
        
        footer.deal = {[unowned self] (btn) in
            
            if let order = self.order,
                order.OrderState == "待支付"{
        
                let payVC = PayContainerViewController()
                payVC.payViewController.payParams = (orderNo:order.OrderNo,price:order.AgentPrice,countPrice:order.SumPrice)
                payVC.modalPresentationStyle = .custom
                self.present(payVC, animated: false)
                payVC.payFinishedDismiss = {[unowned self] (orderNo) in
                    //是否支付成功
                   self.getData()
                }
                
            }else if self.order?.OrderState == "已发货"{
                
               self.showPostVC()
                
            }else{
                let str = "telprompt://13649426876"
                if let url = URL(string: str) {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
        
        tableView.tableFooterView = footer
        
    }
    
    func showPostVC(){
        
        if let info = self.postInfo{
            let str = "https://m.kuaidi100.com/index_all.html?"
            //type=" + info.PostName + "&postid=" + info.PostNo
            let q1 = URLQueryItem(name: "type", value: info.PostName)
            let q2 = URLQueryItem(name: "postid", value: info.PostNo)
            var url = URLComponents(string: str)
            url?.queryItems = [q1,q2]
            if let url = url?.url{
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

extension OrderDetailViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProSnapLst.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderItemProductCell
        let model = ProSnapLst[indexPath.row]
        cell.imgv.kf.setImage(with: model.Main_img.imgRequestUrl)
        cell.nameLab.text = model.ProductName
        cell.priceLab.text = String(format: "￥%.2f", model.BuyPrice)
        cell.standardsLab.text = "规格：" + model.ProductDetiles
        cell.countLab.text = "x\(model.GetCnt)"
        cell.selectionStyle = .none
       
        return cell
    }
}

extension OrderDetailViewController:UITableViewDelegate{
    
}

extension OrderDetailViewController{
    
    func getData(){
        
        guard let oNo = orderNo else {
            return
        }
        
        let api = API.GeOrderDetail(orderno: oNo)
        
        HRequest.getData(api: api) { (data) in
            
            UIView.dismiss(delay: 0){}
            
            self.order = Order.deserialize(from: data["order"].rawString())
            self.mail = Address.deserialize(from: data["mail"].rawString())
            self.ProSnapLst.removeAll()
            for json in data["ProSnapLst"].arrayValue{
                if let model = ProductSnapListItem.deserialize(from: json.rawString()){
                     self.ProSnapLst.append(model)
                }
            }
            
            self.postInfo = PostInfo.deserialize(from:data["postInfo"].rawString())
            
            self.createHeader()
            self.createFooter()
            self.tableView.reloadData()
        }
    }
    
}
