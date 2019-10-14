//
//  ComissionGiveViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ComissionGiveViewController: UITableViewController {

    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var IDTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var remarks: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    
    var price:Float!
    
    var Code:String?
    var times:Int = 60
    var timer:Timer?
    var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        priceLab.textColor = .HBlue
        priceLab.text = String(format: "￥%.2f", price)
        priceTF.keyboardType = .decimalPad
        phoneTF.keyboardType = .decimalPad
        
        codeBtn.addTarget(self, action: #selector(getCode), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7 {
            comfirm()
        }
    }
    
    func comfirm(){
        
        if IDTF.text?.count == 0 {
            self.view.toast(message: "请输入好友ID")
            return
        }
        
        //验证手机号
        if !phoneTF.text!.validatePhone(){
            self.view.toast(message: "请输入正确的手机号")
            return
        }
        
        guard let code = codeTF.text else{
            self.view.toast(message: "请输入正确的验证码")
            return
        }
        
        if code == Code {
        
            guard let price = priceTF.text?.trimmingCharacters(in: .whitespaces) else {
                self.view.toast(message: "请输入正确金额")
                return }
            guard let f = Float(price) else{
                self.view.toast(message: "请输入正确金额")
                return
            }
            
            if f > 0 {
                
                let api = API.GiveCommission(key: UserHelper.UserKey.getValue!, username:IDTF.text!, money: price, remarks: remarks.text ?? "无备注")
                
                HRequest.getData(api: api) { (data) in
                    
                }
            }else{
                self.view.toast(message: "请输入正确金额")
            }
            
        }else{
            self.view.toast(message: "请输入正确的验证码")
        }
    }
    
    @objc func getCode(){
        
        if(phoneTF.text == nil || !phoneTF.text!.validatePhone()){
            view.toast(message: "填写正确的手机号")
            return
        }
        
        times = 60
        phone = phoneTF.text
        codeBtn.isEnabled = false
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        let api = API.GetMobileCode(mobile: phone!)
        
        HRequest.getData(api: api) { (data) in
            self.Code = data.stringValue
            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }

    @objc func timerAction(){
        
        self.codeBtn.setTitle("\(self.times)s", for: .normal)
        self.times -= 1
        if self.times == 0 {
            self.timer?.invalidate()
            self.codeBtn.isEnabled = true
            self.codeBtn.setTitle("重新获取", for: .normal)
        }
    }
    
}
