//
//  UserHelper.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/29.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import UIKit

enum UserHelper {
    
    case UserKey
    case UserData
    case isLogin
    case wxUserName
    
    enum Keys:String{
        case UserKey = "UserName"
        case UserData = "UserData"
        case isLogin = "isLogin"
        case wxUserName = "wxUserName"
    }
}

extension UserHelper {
    
    var getValue:String?{
        switch self {
        case .UserKey:
            return UserDefaults.standard.string(forKey: "UserName")
        case .UserData:
            return UserDefaults.standard.string(forKey: "UserData")
        case .isLogin:
            return UserDefaults.standard.string(forKey: "isLogin") //0,1
        case .wxUserName:
            return UserDefaults.standard.string(forKey: "wxUserName")
        }
    }
    
}


extension UserHelper {
    
   static func showLogin(){
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController?.present(vc!, animated: true, completion: nil)
    }
    
    static func logout(){
        
        UserDefaults.standard.removeObject(forKey: "UserName")
        UserDefaults.standard.removeObject(forKey: "UserData")
        UserDefaults.standard.set("0", forKey: "isLogin")
    }
    
}
