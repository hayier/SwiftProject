//
//  PayFinshiedViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/18.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class PayFinshiedViewController: UIViewController {

    let backView:UIView = {
        let t = UIView()
        t.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        t.alpha = 1
        return t
    }()
    
    let contentV = Bundle.main.loadNibNamed("PayFinishView", owner: nil, options: nil)?.first as! PayFinishView
    
    var bottomConstraint: Constraint?
    
    var payParams:(model:UserModel,orderNo:String,payWay:String,countPrice:Float,price:Float)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
        
        contentV.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        contentV.sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        if payParams.model.Phone.count == 11 {
            var phone = payParams.model.Phone!
            let startIdx = phone.index(phone.startIndex, offsetBy: 3)
            let endIdx = phone.index(phone.startIndex, offsetBy: 7)
            phone = phone.replacingCharacters(in: startIdx...endIdx, with: "****")
            contentV.phoneLab.text = phone
        }else{
            contentV.phoneLab.text = payParams.model.Phone
        }
        contentV.moneyLab.text = String(format: "￥%.2f", payParams.price)
        let youhuiPrice = payParams.countPrice - payParams.price
        contentV.youhuiLab.text = String(format: "(已优惠￥%.2f)", youhuiPrice)
        if payParams.payWay == "jf"{
            contentV.paywayLab.text = String(format: "(剩余%.2f积分)", payParams.model.Integral)
        }else{
            contentV.paywayLab.text = String(format: "(剩余￥%.2f)", payParams.model.Recharge)
        }
        
        contentV.selectedWay = {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    func layoutViews(){
        
        view.addSubview(backView)
        view.addSubview(contentV)
        
        backView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
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
        //self.bottomConstraint?.deactivate()
    }
        
    @objc func backAction(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sureAction(){
        
        let api = API.WXCallback(orderno: self.payParams.orderNo,mode:self.payParams.payWay)
        
        Alamofire.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let commomModel = CommonModel.deserialize(from: json.rawString())
                if commomModel?._success ?? false{
                    
                    self.view.toast(message: commomModel!._message)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("com.tongcheng.payFinished"), object: self.payParams.orderNo)
                    
                }
            case .failure(let e):
                print(e)
            }
        }
    }
    
    
    
}
