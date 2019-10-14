//
//  CommissionTradeViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CommissionTradeViewController: UITableViewController {

    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var zfbTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var remarkTF: UITextField!
    
    var price:Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        priceLab.textColor = .HBlue
        priceLab.text = String(format: "%.2f", price)
        priceTF.keyboardType = .decimalPad

    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            comfirm()
        }
    }
    
    func comfirm(){
    
        //验证手机号
        if zfbTF.text?.count == 0 {
            self.view.toast(message: "请输入正确的账户")
            return
        }
        
        if nameTF.text?.count == 0 {
            self.view.toast(message: "请输入真实姓名")
            return
        }
        
        guard let price = priceTF.text?.trimmingCharacters(in: .whitespaces) else {
            self.view.toast(message: "请输入正确金额")
            return }
        guard let f = Float(price) else{
            self.view.toast(message: "请输入正确金额")
            return
        }
        
        if f > 0 {
            
            let api = API.CommissionCash(key: UserHelper.UserKey.getValue!, money: price, payee_account: zfbTF.text!, payee_real_name: nameTF.text!, Remarks: remarkTF.text ?? "无备注")
            
            HRequest.getData(api: api) { (data) in
                
            }
        }else{
            self.view.toast(message: "请输入正确金额")
        }
        
    }

}
