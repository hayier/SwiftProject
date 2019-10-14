//
//  PayViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/8.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class PayViewController: UIViewController {

    let contentV = Bundle.main.loadNibNamed("PayContentView", owner: nil, options: nil)?.first as! PayContentView
    
    var bottomConstraint: Constraint?
    
    var payParams:(orderNo:String,price:Float,countPrice:Float)?
    
    var completion:((Bool) -> Void)?
    
    let webview = UIWebView()
    
    var model:UserModel?{
        didSet{
            //比较余额  积分 和 实际需要支付价格
            contentV.yueLab.text = String(format: "(剩余￥%.2f)", model!.Recharge)
            contentV.jifenLab.text = String(format: "(剩余%.2f积分)",model!.Integral)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        layoutViews()
        
        contentV.closeBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        contentV.sureBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        contentV.selected = {[unowned self] (idx) in
            //开始支付
            switch idx {
            case 0:
                //支付宝pay
                //self.aliPay()
                self.view.toast(message: "暂不支持支付宝支付\n 请选择其他支付方式")
                return
            case 1:
                //weixin pay
                self.wxpay()
            case 2:
                //余额pay
                let payfinishedVC = PayFinshiedViewController()
                payfinishedVC.payParams = (model:self.model!,orderNo:self.payParams!.orderNo,payWay:"",price:self.payParams!.price,countPrice:self.payParams!.countPrice)
                self.show(payfinishedVC, sender: nil)
                return
            case 3:
                //jifen
                let payfinishedVC = PayFinshiedViewController()
                payfinishedVC.payParams = (model:self.model!,orderNo:self.payParams!.orderNo,payWay:"jf",price:self.payParams!.price,countPrice:self.payParams!.countPrice)
                self.show(payfinishedVC, sender: nil)
                 return
            default:
                return
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(payCompletion(noti:)), name: NSNotification.Name("com.tongcheng.WXPay"), object: nil)
        
    }
    
    func layoutViews(){
        
        view.addSubview(contentV)
       
        //固定height
        let height = UIScreen.main.bounds.size.height * 0.6
        contentV.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.height.equalTo(height)
            //增加弧度
            self.bottomConstraint = $0.bottom.equalTo(contentV.layer.cornerRadius).constraint
            $0.top.equalTo(view.snp.bottom).priority(.low)
        }
        
        //在布局生成之后再操作(是否走完makeConstraints) 否则无效
        self.bottomConstraint?.deactivate()
    }

    func showView(){
        view.bringSubviewToFront(contentV)
        self.bottomConstraint?.activate()
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { (b) in }
    }
    
    @objc func dismissView(){
        
        guard let order = self.payParams?.orderNo else {
            self.view.toast(message: "订单创建失败")
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("com.tongcheng.payFinished"), object: order)
//        self.bottomConstraint?.deactivate()
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.layoutIfNeeded()
//        }) { (b) in
//            if let c = self.completion {
//                c(b)
//            }
//        }
    }

    @objc func payCompletion(noti:Notification){
        
        print(noti.object)
  
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension PayViewController {
    
    func wxpay() {
        guard let order = self.payParams?.orderNo else {
            self.view.toast(message: "订单创建失败")
            return
        }
        
        let jsonStr = UserHelper.UserData.getValue
        
        guard let model  = UserModel.deserialize(from: jsonStr)  else {
            self.view.toast(message: "用户数据错误")
            return
        }
        
        let api = API.WxAppPays(orderno: order,openid:model.AppOpenId)
        
        HRequest.getData(api: api) { (data) in
            
            guard let model = WeixinPay.Params.deserialize(from: data.rawString()) else{
                self.view.toast(message: "支付失败")
                return
            }
            
            let urlString = WeixinPay.createURL(params: model)
            
            //微信SDK调用 方式一
            //WeixinPay.WXPay(params: model)
            
            WeixinPay.pay(urlString: urlString!) { (b) in
                print(b)
                if b {
                    self.payCallBack(mode:"wx")
                }else{
                    self.view.toast(message: "支付失败")
                    NotificationCenter.default.post(name: NSNotification.Name("com.tongcheng.payFinished"), object: order)
                }
            }
        }
    }
    
    
    func aliPay(){
        
        guard let order = self.payParams?.orderNo else {
            self.view.toast(message: "订单创建失败")
            return
        }
        
        let api = API.AlipayOrder(orderno: order)
        
        HRequest.getData(api: api) { (data) in
            //print(data)
            self.webview.loadHTMLString(data.stringValue, baseURL: nil)
        }
        
    }
    
    func payCallBack(mode:String){
        
        guard let order = self.payParams?.orderNo else {
            return
        }
        
        let api = API.WXCallback(orderno: order, mode:mode)
        
        HRequest.getData(api: api, success: { (data) in
            self.view.toast(message: "支付成功")
            NotificationCenter.default.post(name: NSNotification.Name("com.tongcheng.payFinished"), object: order)
        }, faild: { (data) in
            self.view.toast(message: "支付失败")
            NotificationCenter.default.post(name: NSNotification.Name("com.tongcheng.payFinished"), object: order)
        })
    }

}
