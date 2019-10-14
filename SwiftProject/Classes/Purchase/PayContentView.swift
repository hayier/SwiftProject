//
//  PayContentView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/8.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class PayContentView: UIView {

    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet var wayViews: [UIView]!
    
    @IBOutlet weak var yueLab: UILabel!
    @IBOutlet weak var jifenLab: UILabel!
    
    
    var selected:((_ idx:Int)->Void)?
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        
        sureBtn.backgroundColor = .HBlue
        sureBtn.setTitle("取消", for: .normal)
        
        for (idx,view) in wayViews.enumerated() {
            
            if(idx == 0){
                if !AliPay.isAliInstall(){
                    view.isHidden = true
                }
            }else if(idx == 1){
                if !WeixinPay.isWeiXinInstall(){
                    view.isHidden = true
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(tap:)))
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc func tapView(tap:UITapGestureRecognizer){
        guard let idx = wayViews.firstIndex(of: tap.view!) else{
            return
        }
        if selected != nil {
            selected!(idx)
        }
        
    }

}
