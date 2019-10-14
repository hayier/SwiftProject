//
//  LoginTextField.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/27.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UIView {

    let textField = UITextField()
    var validBtn:UIButton{
        let btn = UIButton()
        btn.setTitle("获取验证码", for: .normal)
        btn.backgroundColor = UIColor.groupTableViewBackground
        btn.setTitleColor(UIColor.darkText, for: .normal)
        return btn
    }
    
    var isNeedValidBtn:Bool?{
        didSet{
            validBtn.isHidden = isNeedValidBtn!
            if(!isNeedValidBtn!){
                validBtn.removeFromSuperview()
            }else{
                addSubview(validBtn)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        addSubview(validBtn)
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
  
        validBtn.layer.cornerRadius = 13
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.top.equalTo(5)
            $0.bottom.equalTo(-5)
            $0.right.equalTo(-20).priority(.low)
            $0.right.equalTo(validBtn.snp.left)
        }
        
        validBtn.snp.makeConstraints{
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
            $0.width.equalTo(80)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no coder")
    }

}
