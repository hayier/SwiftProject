//
//  OrderComfirmBottomView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderComfirmBottomView: UIView {

    let countLab = UILabel()
    let sureBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(countLab)
        countLab.text = "需付款：￥99.0"
        
        sureBtn.setTitle("确认付款", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.backgroundColor = .HBlue
        addSubview(sureBtn)
        
        sureBtn.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.width.equalTo(110)
            $0.height.equalTo(45)
        }
        
        countLab.snp.makeConstraints{
            $0.centerY.equalTo(sureBtn.snp.centerY)
            $0.centerX.equalToSuperview().offset(-50)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.groupTableViewBackground
        addSubview(line)
        line.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(1)
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
