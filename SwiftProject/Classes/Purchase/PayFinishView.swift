//
//  PayFinishView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/17.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class PayFinishView: UIView {

   
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    @IBOutlet weak var paywayLab: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var youhuiLab: UILabel!
    
    
    var selectedWay:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sureBtn.backgroundColor = .HBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        paywayLab.superview?.addGestureRecognizer(tap)
        
    }
    
    @objc func tapAction(sender:Any){
        if let selete = selectedWay {
            selete()
        }
    }
    
    
}
