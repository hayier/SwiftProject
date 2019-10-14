//
//  ShopCartBottomView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ShopCartBottomView: UIView {

    let allBtn = UIButton()
    let priceLab = UILabel()
    let countBtn = UIButton()
    let plainLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
//        layer.shadowOffset = CGSize(width: 0, height: -4)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 3
  
        addSubview(allBtn)
        addSubview(plainLab)
        addSubview(priceLab)
        addSubview(countBtn)
        
        allBtn.setImage(UIImage(named: "shop_selected_nomal"), for: .normal)
        allBtn.setImage(UIImage(named: "shopping_cart_Selected"), for: .selected)
        allBtn.setTitle("全选", for: .normal)
        allBtn.setTitle("已全选", for: .selected)
        allBtn.setTitleColor(.black, for: .normal)
        allBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        allBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        plainLab.font = UIFont.boldSystemFont(ofSize: 15)
        plainLab.textColor = .black
        plainLab.text = "合计:"
    
        priceLab.text = "￥0.00"
        
        countBtn.backgroundColor = .HBlue
        countBtn.setTitleColor(.white, for: .normal)
        countBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        countBtn.setTitle("结算(0)", for: .normal)
        
        allBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(15)
        }
        
        plainLab.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-50)
        }
        
        priceLab.snp.makeConstraints{
            $0.left.equalTo(plainLab.snp.right).offset(3)
            $0.centerY.equalToSuperview()
        }
        
        countBtn.snp.makeConstraints{
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(120)
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
