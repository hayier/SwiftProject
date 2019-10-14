//
//  LongImgViewCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class LongImgViewCell: UITableViewCell {

    let imgv = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imgv)
        
        imgv.contentMode = .scaleAspectFit
        imgv.clipsToBounds = true
        
    }
    
    func adjustImage(){
        
        guard let img = imgv.image else {return}
        let size = img.size
        let width = UIScreen.main.bounds.width
        let height = size.height/size.width * width
        
        imgv.snp.remakeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
            $0.height.equalTo(height)
        }
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
