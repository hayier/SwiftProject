//
//  ToastExtension.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/31.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import UIKit
import Toast
import SVProgressHUD

extension UIView{
    
    func toast(message:String){
        self.makeToast(message, duration: 1.0, position: CSToastPositionCenter)
    }
    
    static func show(message:String){
        SVProgressHUD.show(withStatus: message)
    }
    
    static func dismiss(delay:TimeInterval,completion:@escaping SVProgressHUDDismissCompletion){
        SVProgressHUD.dismiss(withDelay: delay, completion:completion)
    }
    
}




