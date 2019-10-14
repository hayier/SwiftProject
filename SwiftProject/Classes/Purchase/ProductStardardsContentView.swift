//
//  ProductStardardsContentView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/8.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ProductStardardsContentView: UIView {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var tf: UITextField!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    let maxCount:Int = 999
    let minCount:Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sureBtn.backgroundColor = .HBlue
        
        priceLab.textColor = .HBlue
        
        plusBtn.superview?.superview?.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        plusBtn.superview?.superview?.layer.borderWidth = 1.0
        
        plusBtn.addTarget(self, action: #selector(delActions(sender:)), for: .touchUpInside)
        minusBtn.addTarget(self, action: #selector(delActions(sender:)), for: .touchUpInside)
        
        tf.text = "1"
    }
    
    @objc func delActions(sender:UIView){
    
        switch sender {
        case minusBtn:
            if let text = tf.text {
                guard var i = Int(text)else{return}
                if(i>minCount){
                    i -= 1
                    tf.text = "\(i)"
                }
            }
        case plusBtn:
            if let text = tf.text {
                guard var i = Int(text)else{return}
                if(i<maxCount){
                    i += 1
                    tf.text = "\(i)"
                }
            }
        case tf:
            if let text = tf.text {
                guard let i = Int(text)else{return}
                if(i>maxCount){
                    tf.text = "\(maxCount)"
                }
                if(i<minCount){
                    tf.text = "\(minCount)"
                }
            }
        default:
            print("have no action here")
        }
        
        if let text = tf.text {
            guard let i = Int(text)else{
                tf.text = "1"
                return
            }
            tf.text = "\(i)"
        }
        
       // NotificationCenter.default.post(name: NSNotification.Name(CartCell.notificationNameItemChanged), object: self);
        
    }

}
