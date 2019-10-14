//
//  ResetPasswordTableViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResetPasswordTableViewController: UITableViewController {

    @IBOutlet weak var oritf: UITextField!
    @IBOutlet weak var ntf: UITextField!
    @IBOutlet weak var rentf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "密码修改"
        
        
        
        
    }

    func changePsw(){
        
        if oritf.text==nil || oritf.text?.count == 0{
            self.view.toast(message: "密码不正确")
            return
        }
        
        if ntf.text?.count==0 || ntf.text != rentf.text{
            self.view.toast(message: "密码不正确")
            return
        }
        
        guard let oldpwd = oritf.text?.trimmingCharacters(in: .whitespaces) else{
            return
        }
        guard let newpwd = ntf.text?.trimmingCharacters(in: .whitespaces)else{
            return
        }
        let api = API.EditMypwd(key: UserHelper.UserKey.getValue!, oldpwd: oldpwd, newpwd: newpwd)
        
        Alamofire.request(api.url, method: .post, parameters: api.params,encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let model = CommonModel.deserialize(from: json.rawString()) else{
                    return
                }
                if model._success{
                    
                    self.view.toast(message: "修改成功")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }else{
                    guard let msg = model._message else{
                        return
                    }
                    self.view.toast(message: msg)
                }
            case .failure(let e):
                print(e)
            }
        }
        
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4 {
            changePsw()
        }
    }
    
}


