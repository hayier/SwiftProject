//
//  MoneyViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class BaseListMoneyViewController: UIViewController {

    let tableView:UITableView = {
        let t = UITableView(frame: .zero)
        t.backgroundColor = .white
        t.allowsMultipleSelection = false
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = UIColor.lightGray
        t.rowHeight = 80
        return t
    }()
    
    let topView = MoneyTopView()
    
    let cellId = "MoneyManageCell"
    
    //Remainer
    var userInfo:UserMoney?
    
    //commission
    var TotalCommission:Float = 0
    var RebateMoney:Float = 0
    
    var dataSource:[Any]?
    
    enum MoneyType:Int {
        case Remainder
        case Commission
        case AvailableComission
    }
    
    var type:MoneyType = .Remainder
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .HBackGray
        
        switch type {
        case .Remainder:
           title = "我的余额"
        case .Commission:
            title = "我的佣金"
        case .AvailableComission:
            title = "我的提现"
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MoneyManageCell", bundle: nil), forCellReuseIdentifier: cellId)
      
        layoutViews()

        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.getData()
        }
        
        tableView.tableFooterView = UIView()
    }
    
    func layoutViews(){
        view.addSubview(tableView)
        view.addSubview(topView)
        
        topView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        
    }
    
    func updateTopView(){
        
        switch type {
        case .Remainder:
            topView.lab1.text = String(format: "可用余额：%.2f元",userInfo!.Recharge)
            topView.sureBtn.setTitle("去充值", for: .normal)
            topView.sureBtn.addTarget(self, action: #selector(investMoney), for: .touchUpInside)
        case .Commission:
            topView.lab1.text = String(format: "总奖励佣金：%.2f元",TotalCommission)
            topView.lab2.text = String(format: "可提现佣金：%.2f元",RebateMoney)
            topView.sureBtn.setTitle("提现", for: .normal)
            
            topView.lab1.snp.remakeConstraints {
                $0.left.equalTo(10)
                $0.top.equalTo(10)
            }
            
            topView.lab2.snp.remakeConstraints{
                $0.left.equalTo(10)
                $0.top.equalTo(topView.lab1.snp.bottom).offset(10)
            }
            
            topView.sureBtn.snp.updateConstraints{
                $0.right.equalTo(-5)
            }
            
            let btn1 = UIButton()
            addBtn(btn: btn1)
            
            let btn2 = UIButton()
            addBtn(btn: btn2)
            btn2.setTitle("积分赠送", for: .normal)
            btn2.snp.remakeConstraints {
                $0.right.equalTo(btn1.snp.left).offset(-5)
                $0.height.equalTo(26)
                $0.width.equalTo(60)
                $0.centerY.equalTo(topView.sureBtn)
            }
            
            topView.sureBtn.addTarget(self, action: #selector(jifenAction(btn:)), for: .touchUpInside)
            btn1.addTarget(self, action: #selector(jifenAction(btn:)), for: .touchUpInside)
            btn2.addTarget(self, action: #selector(jifenAction(btn:)), for: .touchUpInside)
            
        case .AvailableComission:
            topView.lab1.text = "总奖励佣金：10.3万"
            topView.lab2.text = "可提现佣金：10.3万"
            topView.sureBtn.setTitle("提现", for: .normal)
        }
        
    }
    
    func addBtn(btn:UIButton){
        btn.setTitle("积分兑换", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.black
        btn.layer.cornerRadius = 13
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        topView.addSubview(btn)
        
        btn.snp.makeConstraints{
            $0.right.equalTo(topView.sureBtn.snp.left).offset(-5)
            $0.height.equalTo(26)
            $0.width.equalTo(60)
            $0.centerY.equalTo(topView.sureBtn)
        }
    }
    
    @objc func investMoney(){
        let vc = InvestMoneyViewController()
        vc.userInfo = userInfo
        show(vc, sender: nil)
    }
    
}

extension BaseListMoneyViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension BaseListMoneyViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MoneyManageCell
        
        switch type {
        case .Remainder:
            var model = dataSource?[indexPath.row] as! Remainder
            cell.kindLab.text = model.Type
            if model.Type == "充值" || model.Type == "收入" || model.Type == "积分"{
                cell.moneyLab.textColor = .HGreen
                cell.moneyLab.text =  String(format: "+%.2f", model.money)
            }else{
                cell.moneyLab.textColor = .HRed
                cell.moneyLab.text =  String(format: "-%.2f", model.money)
            }
            cell.leftLab.text = model.Balanceofpayments
            cell.rightLab.text = model.DatVerify.dateTtransformSSS()
        case .Commission:
            var model = dataSource?[indexPath.row] as! C_UserRebateItem
            cell.kindLab.text = model.Cat
            if model.Cat != "提现" {
                cell.moneyLab.textColor = .HGreen
                cell.moneyLab.text =  String(format: "+%.2f", model.Money)
            }else{
                cell.moneyLab.textColor = .HRed
                cell.moneyLab.text =  String(format: "-%.2f", model.Money)
            }
            cell.leftLab.text = model.UserRebateName
            cell.rightLab.text = model.DatVerity.dateTtransform()

        default:
            return cell
        }
        
        return cell
    }
    
}


extension BaseListMoneyViewController{
    
    func getData(){
        
        var api:API
        switch type {
        case .Remainder:
            api = API.GeLoanDetail(key: UserHelper.UserKey.getValue!)
            HRequest.getData(api: api){(data) in
                
                let dataArr = data["LoanDetail"].arrayValue
                
                var remainders = [Remainder]()
                for m in dataArr{
                    guard let model = Remainder.deserialize(from: m.rawString()) else{
                        break
                    }
                    remainders.append(model)
                }
                self.dataSource = remainders
                
                let userJson = data["C_UserVM"]
                let userInfo = UserMoney.deserialize(from: userJson.rawString())
                
                self.userInfo = userInfo
                
                
                self.updateTopView()
                self.tableView.reloadData()
                
            }
        case .Commission:
            api = API.GetUserRebateAll(key: UserHelper.UserKey.getValue!)
            HRequest.getData(api: api){(data) in
                
                let dataArr = data["C_UserRebate"].arrayValue
                
                var UserRebates = [C_UserRebateItem]()
                for m in dataArr{
                    guard let model = C_UserRebateItem.deserialize(from: m.rawString()) else{
                        break
                    }
                    UserRebates.append(model)
                }
                self.dataSource = UserRebates
                
                self.TotalCommission = data["TotalCommission"].floatValue
                self.RebateMoney = data["RebateMoney"].floatValue
       
                self.updateTopView()
                self.tableView.reloadData()
                
            }
        case .AvailableComission:
            api = API.GetUserRebateAll(key: UserHelper.UserKey.getValue!)
            print("api")
        }
    }
    
    
    @objc func jifenAction(btn:UIButton){
        
        switch btn.currentTitle {
        case "积分兑换":
            let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "JiFenTradeViewController") as! JiFenTradeViewController
            vc.intergral = self.TotalCommission
            vc.title = btn.currentTitle
            show(vc, sender: nil)
        case "积分赠送":
            let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ComissionGiveViewController") as! ComissionGiveViewController
            vc.price = self.RebateMoney
            vc.title = btn.currentTitle
            show(vc, sender: nil)
        case "提现":
            let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "CommissionTradeViewController") as! CommissionTradeViewController
            vc.price = self.RebateMoney
            vc.title = btn.currentTitle
            show(vc, sender: nil)
        default:
            return
        }
        
    }
    
}
