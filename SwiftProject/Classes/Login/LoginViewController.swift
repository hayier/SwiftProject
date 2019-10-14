//
//  LoginViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/28.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userTf: UITextField!
    @IBOutlet weak var pswTf: UITextField!
    @IBOutlet weak var wxLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(wxLogin))
        wxLoginView.addGestureRecognizer(tap)
        
        if !WeixinPay.isWeiXinInstall() {
            wxLoginView.superview?.isHidden = true
        }
        
        pswTf.isSecureTextEntry = true
        userTf.placeholder = "请输入手机号"
    }
    
    @IBAction func sure(_ sender: Any) {
        
        guard let user = userTf.text?.trimmingCharacters(in: .whitespaces),
         user.validatePhone() else{
            view.toast(message: "请输入正确的手机号")
            return
        }
        guard let psw = pswTf.text?.trimmingCharacters(in: .whitespaces),
            psw.validatePsw() else{
            view.toast(message: "请输入正确的密码")
            return
        }
  
        let api = API.OtherLogin(account: user, pwd: psw)
        
        Alamofire.request(api.url,parameters: api.params)
            .responseJSON { (response) in
                switch(response.result){
                case .success(let value):
                    let json = JSON(value)
                    let commomModel = CommonModel.deserialize(from: json.rawString())
                    if commomModel?._success ?? false{
                        let data = json["_data"].rawString()
                        let user = UserModel.deserialize(from: data)
                        
                        UserDefaults.standard.set(user?.UserName, forKey: "UserName")
                        UserDefaults.standard.set("1", forKey: "isLogin")  //"0"  "1"
                        UserDefaults.standard.set(data,forKey: "UserData")
                        UserDefaults.standard.synchronize()
                        UIView.show(message: "登录成功")
                       
                        UIView.dismiss(delay: 1.5, completion: {
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        })
                    }else{
                        self.view.toast(message: commomModel?._message ?? "未知错误");
                    }
                case .failure(_):
                    print("requet error")
                }
        }
    }
    
    @objc func wxLogin(){
        
        WeixinPay.OAuth { (dic, response, error) in
            if let model = WeixinTokenModel.deserialize(from: dic){
                let api = API.WxAppOpenidRegister(openid: model.openid, token: model.access_token)
                HRequest.getData(api: api, success: { (data) in
                    
                    guard let user = UserModel.deserialize(from: data.rawString()) else{
                        return
                    }
                    
                    UserDefaults.standard.set(user.UserName, forKey:UserHelper.Keys.UserKey.rawValue)
                    UserDefaults.standard.set("1", forKey: UserHelper.Keys.isLogin.rawValue)  //"0"  "1"
                    UserDefaults.standard.set(data.rawString(),forKey: UserHelper.Keys.UserData.rawValue)
                    UserDefaults.standard.synchronize()
                    UIView.show(message: "登录成功")
                    
                    UIView.dismiss(delay: 1.5, completion: {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                    
                }, faild: { (data) in
                    let key = data.stringValue
                    UserDefaults.standard.setValue(key, forKey: UserHelper.Keys.wxUserName.rawValue)
                    UserDefaults.standard.synchronize()
                    let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                    vc.type = 1
                    self.show(vc, sender: nil)
                })
            }
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }

    @IBAction func dismissVC(_ sender: Any) {
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func forgetPsw(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.type = 2
        self.show(vc, sender: nil)
        
    }
}
