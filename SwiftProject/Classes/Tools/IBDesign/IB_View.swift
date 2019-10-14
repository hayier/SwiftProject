//
//  IB_View.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/27.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

@IBDesignable
class IB_View: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.HGray.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
    
//    @IBInspectable var cornerRadius:CGFloat = 10.0{
//        didSet{
//            layer.cornerRadius = cornerRadius
//        }
//    }
//
//    @IBInspectable var borderWidth:CGFloat = 1.0{
//        didSet{
//            layer.borderWidth = borderWidth
//        }
//    }
//
//    @IBInspectable var borderColor:UIColor = UIColor.HBackGray {
//        didSet{
//            layer.borderColor = borderColor.cgColor
//        }
//    }
}

@IBDesignable
class IB_Button: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 10.0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

}

@IBDesignable
class IB_Label: UILabel {
    
    @IBInspectable var cornerRadius:CGFloat = 10.0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
}

@IBDesignable
class IB_TextFiled: UITextField {
    
    @IBInspectable var cornerRadius:CGFloat = 10.0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}


