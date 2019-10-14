//
//  StandardsCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/8.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class StandardsCell: UICollectionViewCell {
    
    let nameLab = UILabel()
    
    override var isSelected: Bool{
        didSet{
            if isSelected {
                nameLab.textColor = .white
                nameLab.backgroundColor = .HBlue
            }else{
                nameLab.textColor = .HTextGray
                nameLab.backgroundColor = .HBackGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLab)
        nameLab.textAlignment = .center
        nameLab.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 5.0;
        contentView.clipsToBounds = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
