//
//  RegisterViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/28.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var valideTf: UITextField!
    
    @IBOutlet weak var valideBtn: IB_Button!
    
    var type:Int = 0
    
    var timer:Timer?
    
    var times = 60
    
    var code:String?
    
    var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        switch type{
        case 0:titleLab.text = "注册"
        case 1:titleLab.text = "绑定手机"
        case 2:titleLab.text = "验证手机"
        default:
            break
        }
        
        valideTf.isSecureTextEntry = true
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func valideAction(_ sender: Any) {
        
        if(phoneTf.text == nil || !phoneTf.text!.validatePhone()){
            view.toast(message: "填写正确的手机号")
            return
        }
        
        times = 60
        phone = phoneTf.text
        valideBtn.isEnabled = false
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        let api = API.GetMobileCode(mobile: phoneTf.text!)
        
        HRequest.getData(api: api) { (data) in
            self.code = data.stringValue
            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    
    
    @objc func timerAction(){

        self.valideBtn.setTitle("\(self.times)s", for: .normal)
        self.times -= 1
        if self.times == 0 {
            self.timer?.invalidate()
            self.valideBtn.isEnabled = true
            self.valideBtn.setTitle("重新获取", for: .normal)
        }
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSetPswViewController",
            let vc = segue.destination as? SetPswViewController {
                vc.phone = phone
                vc.type = type
            }
    }
    
    @IBAction func sureAction(_ sender: Any) {
        
        if(phoneTf.text == nil || !phoneTf.text!.validatePhone()){
            view.toast(message: "请输入正确的手机号")
            return
        }
        
        if(valideTf.text != code || valideTf.text == nil){
            view.toast(message: "验证码不正确")
            return
        }
        
        if type == 1{
            
            let api = API.WxAppBindingMobile(phone: phone!, wxusername: UserHelper.wxUserName.getValue!)
            
            HRequest.getData(api: api, success: { (data) in
                
                self.performSegue(withIdentifier: "ToSetPswViewController", sender: nil)
                
            }) { (data) in
                self.view.toast(message: "手机绑定失败")
            }
            
        }else{
            self.performSegue(withIdentifier: "ToSetPswViewController", sender: nil)
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.timer?.invalidate()
        self.valideBtn.setTitle("重新获取", for: .normal)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    
}
