//
//  SetPswViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/28.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SetPswViewController: UIViewController {

    
    @IBOutlet weak var onePsw: UITextField!
    @IBOutlet weak var secPsw: UITextField!
    @IBOutlet weak var sureBtn: IB_Button!
    
    var phone:String?
    var type:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onePsw.isSecureTextEntry = true
        secPsw.isSecureTextEntry = true
        
        switch type {
        case 0: sureBtn.setTitle("完成注册", for: .normal)
        case 1: sureBtn.setTitle("完成绑定", for: .normal)
        case 2: sureBtn.setTitle("确定", for: .normal)
        default:
            break
        }
        
    }
    

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func registerFinished(_ sender: Any) {
        
        if onePsw.text == nil || !onePsw.text!.validatePsw() {
            view.toast(message: "密码格式不正确")
            return
        }
        
        if onePsw.text != secPsw.text {
            view.toast(message: "请输入相同的密码")
            return
        }
        
        switch type {
        case 0,1:
            
            let api = API.Register(Phone: phone!, pwd: onePsw.text!)
            
            HRequest.getData(api: api, success: { (data) in
                UIView.show(message: "注册成功，正在登录...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    let api = API.OtherLogin(account: self.phone!, pwd: self.onePsw.text!)
                    
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
                    
                })
                
                UIView.dismiss(delay: 1.5, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }) { (data) in
                
                //key : _message
                //- value : 手机号码已经被注册
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        case 2:
            
            let api = API.EditPwd(phone: phone!, pwd: onePsw.text!)
            
            HRequest.getData(api: api, success: { (data) in
                self.view.toast(message: "修改成功，请登录")
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }) { (data) in
                self.view.toast(message: "修改失败，请联系客服")
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            
        default:
            break
        }
        
        
        
    }
    
}
