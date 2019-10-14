//
//  InvestMoneyViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InvestMoneyViewController: UIViewController {

    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        let width = (UIScreen.main.bounds.width - 60)*0.5
        layout.itemSize = CGSize(width: width, height: 100)
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.showsVerticalScrollIndicator = false
        c.backgroundColor = .white
        c.allowsMultipleSelection = false
        return c
    }()
    
    let topView = MoneyTopView()
    
    let cellId = "InvestMoneyCell"
    
    var userInfo:UserMoney?
    
    var dataSource = [RechargeItem]()
    
    var selectedItem:RechargeItem?
    
    let moneyBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "充值"
        
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InvestMoneyCell.self, forCellWithReuseIdentifier: cellId)
        
        layoutViews()
        
        topView.sureBtn.isHidden = true
        
        guard let info = userInfo else {
            return
        }
        
        topView.lab1.text = "账户：" +  info.Name
        topView.lab2.text = String(format: "剩余金额：%.2f元",info.Money)
        
        moneyBtn.setTitle("自定义充值金额", for: .normal)
        moneyBtn.setTitleColor(.HBlue, for: .normal)
        moneyBtn.addTarget(self, action: #selector(customMoney), for: .touchUpInside)
        
        getData()
    }
    
    func layoutViews(){
        view.addSubview(topView)
        
        let titleView = UIView()
        let titleLab = UILabel()
        titleLab.text = "充值金额"
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(titleView)
        titleView.addSubview(titleLab)
        
        view.addSubview(collectionView)
        
        view.addSubview(moneyBtn)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确认充值", for: .normal)
        sureBtn.backgroundColor = .HBlue
        sureBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        view.addSubview(sureBtn)
        
        topView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.height.equalTo(60)
        }
        
        titleView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
            $0.height.equalTo(100)
        }
        
        titleLab.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(150)
        }
        
        moneyBtn.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.bottom.equalTo(sureBtn.snp.top).offset(-30)
        }
        
        sureBtn.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.bottom.equalTo(-30)
            $0.height.equalTo(40)
        }
    }
    
    @objc func customMoney(){
       
        let alert = UIAlertController(title: "充值金额", message: "输入您想要充值的金额", preferredStyle: .alert)
        
        alert.addTextField { (tf) in
            tf.placeholder = "充值金额"
        }
        
        let ac1 = UIAlertAction(title: "取消", style: .cancel) { (ac) in
            
        }
        
        let ac2 = UIAlertAction(title: "确定", style: .default) { (ac) in
            if let str = alert.textFields?.first?.text {
                self.customMoneyPay(str: str)
            }
        }
        
        alert.addAction(ac1)
        alert.addAction(ac2)
       
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sureBtnClick(){
        
        if let item = selectedItem {
            
            let sheet = UIAlertController(title: "充值", message: nil, preferredStyle: .actionSheet)
            
            let ac1 = UIAlertAction(title: "微信支付", style: .default) { (ac) in
                self.RechargeParty(id: item.ID)
            }
            
            let ac2 = UIAlertAction(title: "支付宝支付", style: .default) { (ac) in
               self.view.toast(message: "暂不支持支付宝支付\n 请选择其他支付方式")
            }
            
            let ac3 = UIAlertAction(title: "取消", style: .cancel) { (ac) in
                
            }
            
            sheet.addAction(ac1)
            sheet.addAction(ac2)
            sheet.addAction(ac3)
            
            self.present(sheet, animated: true, completion: nil)
            
            
        }else{
            self.view.toast(message: "请选择充值金额")
        }
    }

}

extension InvestMoneyViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InvestMoneyCell
        let model = dataSource[indexPath.row]
        cell.moneyLab.text = model.ParametersVal + "元"
        return cell
    }
}

extension InvestMoneyViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = dataSource[indexPath.item]
    }
    
}

extension InvestMoneyViewController{
    
    func getData(){
        let api = API.GetRecharge
        
        HRequest.getData(api: api){
            let dataArr = $0.arrayValue
            for json in dataArr {
                guard let model = RechargeItem.deserialize(from: json.rawString()) else{
                    continue
                }
                self.dataSource.append(model)
            }
            self.collectionView.reloadData()
        }
    }
    
    
    // 充值下单
    func RechargeParty(id:Int){
        
        func pay(){
            let api = API.RechargeParty(key: UserHelper.UserKey.getValue!, id:"\(id)")
            UIView.dismiss(delay: 0) {}
            Alamofire.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let commomModel = CommonModel.deserialize(from: json.rawString())
                    if commomModel?._success ?? false{
                        
                        let code = json["_data"].stringValue
                        
                        if let payInfo = commomModel?._message,
                            let payModle = WeixinPay.Params.deserialize(from: payInfo),
                            let urlString = WeixinPay.createURL(params: payModle){
                            WeixinPay.pay(urlString: urlString, completionHandler: { (b) in
                                if(b){
                                    let callApi = API.WxRecharge(key: UserHelper.UserKey.getValue!, id: code)
                                    HRequest.getData(api: callApi, success: { (data) in
                                        self.view.toast(message: "支付成功")
                                    }, faild: { (_) in
                                        self.view.toast(message: "支付失败")
                                    })
                                }else{
                                    self.view.toast(message: "支付失败")
                                }
                            })
                        }
                        
                        
                    }else{
                        guard let message = commomModel?._message else{
                            return
                        }
                        UIApplication.shared.keyWindow?.makeToast(message)
                    }
                case .failure(let e):
                    print(e)
                }
            }
        }
        
        if UserHelper.wxUserName.getValue == nil,
           let phone = userInfo?.Phone{
            
            WeixinPay.OAuth { (dic, response, error) in
                if error != nil {
                    self.view.toast(message: "微信授权失败")
                    return
                }
                if let model = WeixinTokenModel.deserialize(from: dic){
                    let api = API.WxAppOpenidRegister(openid: model.openid, token: model.access_token)
                    HRequest.getData(api: api, success: { (data) in
                        
                    }, faild: { (data) in
                        let key = data.stringValue
                        UserDefaults.standard.setValue(key, forKey: UserHelper.Keys.wxUserName.rawValue)
                        UserDefaults.standard.synchronize()
                        UIView.show(message: "准备支付")
                        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                            let api = API.WxAppBindingMobile(phone: phone , wxusername: key)
                            HRequest.getData(api: api, success: { (data) in
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    pay()
                                })
                            })
                        })
                    })
                }
            }
        }else{
            pay()
        }
    }
    
    
    func customMoneyPay(str:String){
        
        guard let money = Float(str) else {
            self.view.toast(message: "请输入正确金额")
            return
        }
        
        if money > 100000 {
            self.view.toast(message: "请输入不大于10万的金额")
        }
        
        let api = API.RechargePartyCopy(key: UserHelper.UserKey.getValue!, money: "\(money)")
        
        Alamofire.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let commomModel = CommonModel.deserialize(from: json.rawString())
                if commomModel?._success ?? false{
                    
                    let code = json["_data"].stringValue
                    
                    if let payInfo = commomModel?._message,
                        let payModle = WeixinPay.Params.deserialize(from: payInfo),
                        let urlString = WeixinPay.createURL(params: payModle){
                        WeixinPay.pay(urlString: urlString, completionHandler: { (b) in
                            if(b){
                                let callApi = API.WxRecharge(key: UserHelper.UserKey.getValue!, id: code)
                                HRequest.getData(api: callApi, success: { (data) in
                                    self.view.toast(message: "支付成功")
                                }, faild: { (_) in
                                    self.view.toast(message: "支付失败")
                                })
                            }else{
                                self.view.toast(message: "支付失败")
                            }
                        })
                    }
                    
                    
                }else{
                    guard let message = commomModel?._message else{
                        return
                    }
                    UIApplication.shared.keyWindow?.makeToast(message)
                }
            case .failure(let e):
                print(e)
            }
        }
        
    }
    
    
}
