//
//  UserTableViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import MonkeyKing

class UserTableViewController: UITableViewController {

    
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var userTypeLab: UILabel!
    
    @IBOutlet var moneyViews: [UIView]!
    @IBOutlet var orderViews: [UIView]!
    
    @IBOutlet weak var ownMoneyLab: UILabel!
    @IBOutlet weak var earnedLab: UILabel!
    @IBOutlet weak var ti_xianLab: UILabel!
    @IBOutlet weak var jifen_Lab: UILabel!
    
    @IBOutlet weak var logout_Lab: UILabel!
    
    var model:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerImgView.layer.cornerRadius = 30
        
        for v in moneyViews{
            let tap = UITapGestureRecognizer(target: self, action: #selector(moneyTap(gs:)))
            v.addGestureRecognizer(tap)
        }
        
        for v in orderViews{
            let tap = UITapGestureRecognizer(target: self, action: #selector(orderTap(gs:)))
            v.addGestureRecognizer(tap)
        }
        
    }
    
    func gradientLab(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.85, green: 0.69, blue: 0.42, alpha: 1).cgColor, UIColor(red: 0.95, green: 0.8, blue: 0.56, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.frame = userTypeLab.superview!.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        userTypeLab.superview!.layer.insertSublayer(gradient, at: 0)
        userTypeLab.superview!.layer.cornerRadius = 8;
        userTypeLab.superview!.clipsToBounds = true
    }
    
    @objc func moneyTap(gs:UITapGestureRecognizer){
        
        if UserHelper.UserKey.getValue == nil{
            UserHelper.showLogin()
            return
        }
        
        let i = moneyViews.firstIndex(of: gs.view!)
        if i == 2 {
            let vc = BaseListMoneyViewController()
            vc.type = BaseListMoneyViewController.MoneyType.Commission
            vc.hidesBottomBarWhenPushed = true
            show(vc, sender: nil)
            return
        }
        guard let idx = i else{return}
        let vc = BaseListMoneyViewController()
        vc.type = BaseListMoneyViewController.MoneyType(rawValue: idx) ?? .Remainder
        vc.hidesBottomBarWhenPushed = true
        show(vc, sender: nil)
    }
    
    @objc func orderTap(gs:UITapGestureRecognizer){
        
        if UserHelper.UserKey.getValue == nil{
            UserHelper.showLogin()
            return
        }
        
        let i = orderViews.firstIndex(of: gs.view!)
        guard let idx = i else { return}
        if idx<4{
            let vc = OrderViewController()
            vc.idx = idx+1
            vc.hidesBottomBarWhenPushed = true
            show(vc, sender: nil)
        }else{
            let vc = OrderItemViewController()
            vc.type = .Service
            vc.title = "售后"
            vc.hidesBottomBarWhenPushed = true
            show(vc, sender: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if UserHelper.UserKey.getValue == nil{
            UserHelper.showLogin()
            return
        }
        
        //section0
        if(indexPath.section==0){
            //个人信息
            let setting = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "UserSettingTableViewController") as! UserSettingTableViewController
            setting.model = self.model
            show(setting, sender: nil)
        }else if(indexPath.section==1){
            //订单信息
            if(indexPath.row==0){
                //更多订单
                let vc = OrderViewController()
                vc.hidesBottomBarWhenPushed = true
                show(vc, sender: nil)
            }
        }else if(indexPath.section==2){
            
            //点击跳转
            switch indexPath.row{
                case 1:
                    let vc = LessonViewController()//焕颜课程
                    vc.hidesBottomBarWhenPushed = true
                    show(vc, sender: nil)
                case 3:
                    let vc = TeamViewController()
                    vc.hidesBottomBarWhenPushed = true
                    show(vc, sender: nil)//我的团队
                case 5: getFriends()  //邀请好友
                case 7:
                    let vc = AddressListViewController()
                    //vc.hidesBottomBarWhenPushed = true
                    show(vc, sender: nil)//我的收货地址
                case 9:
                //联系客服
                    let str = "telprompt://13649426876"
                    if let url = URL(string: str) {
                        UIApplication.shared.openURL(url)
                }
            case 11:
                logout()
            default: break
            }
            
        }else{
            
        }
    }

}


extension UserTableViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserHelper.UserKey.getValue != nil {
            getData()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
}

extension UserTableViewController {
    
    func getData(){
        
        let api = API.GetUser(key: UserHelper.UserKey.getValue!)
        
        HRequest.getData(api: api) { (data) in
            
            guard var model = UserModel.deserialize(from: data["C_User"].rawString()) else{
                return
            }
            
            model.userTypeName = data["userTypeName"].stringValue
            model.MyCommission = data["MyCommission"].floatValue
            
            UserDefaults.standard.set(model.toJSONString(), forKey: UserHelper.Keys.UserData.rawValue)
            
            self.model = model;
            let img = #imageLiteral(resourceName: "account_avatar")
            self.headerImgView.kf.setImage(with: URL(string: model.PortraitUrl), placeholder: img)
            
            self.nameLab.text = model.Name
            self.userTypeLab.text = model.userTypeName
            self.ownMoneyLab.text = String(format: "%.2f元", model.Recharge)
            self.earnedLab.text = String(format: "%.2f元", model.MyCommission)
            self.ti_xianLab.text = String(format: "%.2f元", model.RebateMoney)
            self.jifen_Lab.text = String(format: "%.2f", model.Integral)
            self.userTypeLab.sizeToFit()
            self.userTypeLab.superview?.layoutIfNeeded()
            self.logout_Lab.text = "退出登录"
            //self.view.layoutIfNeeded()
            self.gradientLab()
            self.tableView.reloadData()
        }
    }
    
    func logout(){
        
        let alert = UIAlertController(title: "退出登录", message:"确定要退出登录吗？", preferredStyle:.alert)
        let action = UIAlertAction(title: "取消", style: .cancel) { (a) in
            
        }
        let action1 = UIAlertAction(title: "确定", style: .destructive) { (a) in
            UserHelper.logout()
            self.model = nil;
            let img = #imageLiteral(resourceName: "account_avatar")
            self.headerImgView.image = img
            self.nameLab.text = "请登录..."
            self.userTypeLab.text = "无"
            self.ownMoneyLab.text = "0.00元"
            self.earnedLab.text = "0.00元"
            self.ti_xianLab.text = "0.00元"
            self.jifen_Lab.text = "0.00"
            self.logout_Lab.text = "已退出"
        }
        
        alert.addAction(action)
        alert.addAction(action1)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func getFriends(){
        
        let api = API.AppInvitelinks(key: UserHelper.UserKey.getValue!)
        
        HRequest.getData(api: api) { (data) in
            
            let sheet = UIAlertController(title: "邀请好友", message: "推荐给好友，获取积分，享佣金分成", preferredStyle: .actionSheet)
            
            guard let url = URL(string: data.stringValue) else{
                self.view.toast(message: "链接失效")
                return
            }
            
            let ac1 = UIAlertAction(title: "微信好友", style: .default) { (ac) in
                let img = #imageLiteral(resourceName: "payment_icon3")
                let info = MonkeyKing.Info(title:"焕颜坊注册", description: "推荐给好友，获取积分，享佣金分成" , thumbnail: img, media: .url(url))
                let message = MonkeyKing.Message.weChat(.session(info: info))
                
                MonkeyKing.deliver(message) { (result) in
                    
                }
            }
            
            let ac2 = UIAlertAction(title: "微信朋友圈", style: .default) { (ac) in
                let img = #imageLiteral(resourceName: "payment_icon3")
                let info = MonkeyKing.Info(title:"焕颜坊注册", description: "推荐给好友，获取积分，享佣金分成" , thumbnail: img, media: .url(url))
                let message = MonkeyKing.Message.weChat(.timeline(info: info))
                
                MonkeyKing.deliver(message) { (result) in
                    
                }
            }
            
            let ac3 = UIAlertAction(title: "取消", style: .cancel) { (ac) in
                
            }
            
            sheet.addAction(ac1)
            sheet.addAction(ac2)
            sheet.addAction(ac3)
            
            self.present(sheet, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
}
