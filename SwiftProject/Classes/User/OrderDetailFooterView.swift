//
//  OrderDetailFooterView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/17.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderDetailFooterView: UIView {

    let countFooterView = Bundle.main.loadNibNamed("OrderComfirmFooter", owner: self, options: nil)?.first as! OrderComfirmFooter

    let infoFooterView = Bundle.main.loadNibNamed("OrderInfoView", owner: self, options: nil)?.first as! OrderInfoView
    
    let dealBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("联系客服", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = .white
        return btn
    }()
    
    var deal:((_ btn:UIButton)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .groupTableViewBackground
        
        addSubview(countFooterView)
        addSubview(infoFooterView)
        addSubview(dealBtn)
        
        dealBtn.addTarget(self, action: #selector(dealAction(btn:)), for: .touchUpInside)
        
        countFooterView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(192)
        }
        
        infoFooterView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(countFooterView.snp.bottom).offset(10)
            $0.height.equalTo(190)
        }
        
        dealBtn.snp.makeConstraints{
            $0.top.equalTo(infoFooterView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dealAction(btn:UIButton){
        if let deal = self.deal {
            deal(btn)
        }
    }
    
}
