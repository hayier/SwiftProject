//
//  InvestMoneyCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class InvestMoneyCell: UICollectionViewCell {
    
    let moneyLab = UILabel()
    let imgv = UIImageView()
    
    override var isSelected: Bool{
        didSet{
            if(isSelected){
                imgv.isHidden = false
                moneyLab.textColor = UIColor.HBlue
                contentView.layer.borderColor = UIColor.HBlue.cgColor
            }else{
                imgv.isHidden = true
                moneyLab.textColor = UIColor.black
                contentView.layer.borderWidth = 1
                contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.HGray.cgColor
        
        contentView.addSubview(moneyLab)
        contentView.addSubview(imgv)
        
        moneyLab.font = UIFont.boldSystemFont(ofSize: 15)
        
        imgv.image = #imageLiteral(resourceName: "selected")
        imgv.isHidden = true
        
        moneyLab.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        imgv.snp.makeConstraints{
            $0.right.bottom.equalToSuperview()
            //$0.width.height.equalTo(25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
