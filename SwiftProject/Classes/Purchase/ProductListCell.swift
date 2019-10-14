//
//  ProductListCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {

    let imgv = UIImageView()
    let nameLab = UILabel()
    let priceLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(imgv)
        contentView.addSubview(nameLab)
        contentView.addSubview(priceLab)
        
        nameLab.text = "这是name这个n名字可能有点长，但是都只能显示固定行"
        priceLab.text = "这是价格"
        nameLab.font = UIFont.systemFont(ofSize: 14)
        priceLab.font = UIFont.boldSystemFont(ofSize: 15)
        
        imgv.layer.cornerRadius = 10
        imgv.clipsToBounds = true
    
        nameLab.snp.makeConstraints{
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
            $0.bottom.equalTo(priceLab.snp.top).offset(-8)
        }
        priceLab.snp.makeConstraints{
            $0.left.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        imgv.snp.remakeConstraints{
            $0.leftMargin.topMargin.rightMargin.equalToSuperview()
            $0.height.equalTo(imgv.snp.width)
        }
        
        let serverImages = [
            "http://pic15.nipic.com/20110628/1369025_192645024000_2.jpg",
            "http://pic37.nipic.com/20140113/8800276_184927469000_2.png",
            "http://k.zol-img.com.cn/sjbbs/7692/a7691515_s.jpg",
            "http://pic15.nipic.com/20110628/1369025_192645024000_2.jpg",
            "http://pic37.nipic.com/20140113/8800276_184927469000_2.png"
        ]
        let str = serverImages[Int(arc4random())%serverImages.count]
        imgv.kf.setImage(with: URL(string: str), placeholder:UIImage(named: "color_icon"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
