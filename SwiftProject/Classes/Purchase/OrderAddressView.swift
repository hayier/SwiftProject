//
//  OrderAddressView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/31.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderAddressView: UIView {

    var cell:AddressCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let cell = Bundle.main.loadNibNamed("AddressCell", owner: self, options: nil)?.first as! AddressCell
        self.cell = cell
        addSubview(cell)
        
        cell.selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(contentTap))
        cell.contentView.addGestureRecognizer(tap)
        
        let line = UIView()
        line.backgroundColor = UIColor.groupTableViewBackground
        addSubview(line)

        cell.snp.makeConstraints{
            $0.right.left.top.equalToSuperview()
            $0.bottom.equalTo(line.snp.top)
        }
        
        line.snp.makeConstraints{
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        cell.contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func contentTap(){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.address.selectNew"), object: nil)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
