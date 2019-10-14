//
//  ProductDetailBottomView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/13.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ProductDetailBottomView: UIView {

    let cartBtn = UIButton()
    let buyBtn = UIButton()
    let shopImgBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tab_shopping"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cartBtn)
        addSubview(buyBtn)
        addSubview(shopImgBtn)
        
        cartBtn.setTitle("加入购物车", for: .normal)
        cartBtn.setTitleColor(.HBlue, for: .normal)
        cartBtn.layer.borderWidth = 1
        cartBtn.layer.borderColor = UIColor.HBlue.cgColor
        
        buyBtn.backgroundColor = .HBlue
        buyBtn.setTitle("立即购买", for: .normal)
        
        let iwidth = (UIScreen.main.bounds.width - 100)*0.5
        
        cartBtn.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(iwidth)
            $0.right.equalTo(buyBtn.snp.left).offset(-10)
            $0.top.equalTo(4)
        }
        
        buyBtn.snp.makeConstraints{
            $0.right.equalTo(-10)
            $0.height.equalTo(40)
            $0.width.equalTo(iwidth)
            $0.top.equalTo(4)
        }
        
        shopImgBtn.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.top.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
