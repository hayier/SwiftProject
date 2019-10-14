//
//  JiFenTradeViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class JiFenTradeViewController: UITableViewController {

    
    @IBOutlet weak var intergralLab: UILabel!
    @IBOutlet weak var priceTF: UITextField!
    
    var intergral:Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intergralLab.textColor = .HBlue
        intergralLab.text = String(format: "￥%.2f", intergral)
        priceTF.keyboardType = .decimalPad
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3{
            comfirm()
        }
    }
    
    
    func comfirm(){
        
        guard let jf = priceTF.text?.trimmingCharacters(in: .whitespaces) else {
             self.view.toast(message: "请输入正确金额")
            return }
        guard let f = Float(jf) else{
             self.view.toast(message: "请输入正确金额")
            return
        }
        
        if f > 0 {
            
            let api = API.IntegralExchange(key: UserHelper.UserKey.getValue!,Integral: jf)
                
                HRequest.getData(api: api, success: { (data) in
                    UIApplication.shared.keyWindow?.toast(message: "兑换成功")
                    self.navigationController?.popToRootViewController(animated: true)
                })
            
        }else{
            self.view.toast(message: "请输入正确金额")
        }
    }
}
