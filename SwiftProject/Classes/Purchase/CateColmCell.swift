//
//  CateColmCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/9.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CateColmCell: UITableViewCell {

    let selectedLine = UIView()
    let nameLab = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(selectedLine)
        contentView.addSubview(nameLab)
        
        selectedLine.snp.makeConstraints{
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(3)
        }
        
        nameLab.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            nameLab.textColor = .HBlue
            selectedLine.backgroundColor = .HBlue
            contentView.backgroundColor = .white
        }else{
            nameLab.textColor = .HTextBlack
            selectedLine.backgroundColor = .clear
            contentView.backgroundColor = .HBackGray
        }
    }
    
}
