//
//  SingleImgCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class SingleImgCell: UICollectionViewCell {
    
    var imgv = UIImageView()
    
    let serverImages = [
        "http://pic15.nipic.com/20110628/1369025_192645024000_2.jpg",
        "http://pic37.nipic.com/20140113/8800276_184927469000_2.png",
        "http://k.zol-img.com.cn/sjbbs/7692/a7691515_s.jpg",
        "http://pic15.nipic.com/20110628/1369025_192645024000_2.jpg",
        "http://pic37.nipic.com/20140113/8800276_184927469000_2.png"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgv)
        
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.layer.cornerRadius = 10
        imgv.clipsToBounds = true
        imgv.image = UIImage(named: "color_icon")
        imgv.contentMode = .scaleAspectFill
        
        let str = serverImages[Int(arc4random())%serverImages.count]
        imgv.kf.setImage(with: URL(string: str))

        imgv.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.top.equalTo(5)
            $0.bottom.equalTo(-5)
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
