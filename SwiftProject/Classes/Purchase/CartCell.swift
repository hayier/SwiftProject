//
//  CartCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/6.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var imgv: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var standardsLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var tf: UITextField!
    
    let maxCount:Int = 999
    let minCount:Int = 1
    
    static let notificationNameItemChanged = "com.post.cartItemChanged"
    
    typealias CartItem = (isSelected:Bool,count:Int,data:[String:String])
    var model:CartDataItem?{
        didSet{
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        plusBtn.superview?.superview?.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        plusBtn.superview?.superview?.layer.borderWidth = 1
    
        plusBtn.addTarget(self, action: #selector(delActions(sender:)), for: .touchUpInside)
        minusBtn.addTarget(self, action: #selector(delActions(sender:)), for: .touchUpInside)
        selectBtn.addTarget(self, action: #selector(delActions(sender:)), for: .touchUpInside)
        
        selectBtn.setImage(UIImage(named: "shop_selected_nomal"), for: .normal)
        selectBtn.setImage(UIImage(named: "shopping_cart_Selected"), for: .selected)
        
        tf.addTarget(self, action: #selector(delActions(sender:)), for: .editingChanged)
    
    }
    
    func fillData(){
        guard let m = model else {return}
        selectBtn.isSelected = m.IsCheck
        tf.text = "\(m.GetCnt)"
        imgv.kf.setImage(with: m.ProductImg.imgRequestUrl)
        nameLab.text = m.ProductName
        standardsLab.text = "规格: " + m.attrvalue
        priceLab.text = String(format: "￥%.2f", m.attr_price)
        
    }
    
    @objc func delActions(sender:UIView){
        
        switch sender {
        case selectBtn:
            selectBtn.isSelected = !selectBtn.isSelected
            model?.IsCheck = selectBtn.isSelected
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
            model?.GetCnt = i
        }

        NotificationCenter.default.post(name: NSNotification.Name(CartCell.notificationNameItemChanged), object: self, userInfo:["view":sender]);

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
