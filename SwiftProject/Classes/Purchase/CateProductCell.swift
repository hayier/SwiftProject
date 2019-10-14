//
//  CateProductCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/9.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CateProductCell: UICollectionViewCell {
    
    let imgv = UIImageView()
    let nameLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgv)
        contentView.addSubview(nameLab)
        contentView.clipsToBounds = true
        imgv.layer.cornerRadius = 10
        imgv.layer.borderWidth = 1
        imgv.layer.borderColor = UIColor.HBackGray.cgColor
        imgv.clipsToBounds = true
        
        nameLab.font = UIFont.systemFont(ofSize: 12)
        nameLab.textAlignment = .center
        nameLab.lineBreakMode = .byClipping
        
        imgv.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(imgv.snp.width)
        }
        
        nameLab.snp.makeConstraints{
            $0.top.equalTo(imgv.snp.bottom).offset(8)
            $0.left.equalTo(2)
            $0.right.equalTo(-2)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
