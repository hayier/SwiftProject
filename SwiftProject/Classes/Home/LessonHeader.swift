//
//  LessonHeader.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class LessonHeader: UIView {

    let imgv = UIImageView()
    let titleLab = UILabel()
    let priceLab = UILabel()
    let descLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgv)
        addSubview(titleLab)
        addSubview(priceLab)
        addSubview(descLab)
        
        imgv.layer.cornerRadius = 10
        imgv.clipsToBounds = true
        imgv.image = #imageLiteral(resourceName: "home_banner")
        
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        titleLab.text = "课程标题"

        priceLab.font = UIFont.systemFont(ofSize: 15)
        priceLab.textColor = UIColor.darkText
        priceLab.text = "免费"
        
        descLab.numberOfLines = 0
        descLab.font = UIFont.systemFont(ofSize: 14)
        descLab.textColor = UIColor.darkText
        
        imgv.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.top.equalTo(10)
            $0.height.equalTo(150)
        }
        
        titleLab.snp.makeConstraints{
            $0.left.equalTo(imgv.snp.left).offset(8)
            $0.top.equalTo(imgv.snp.bottom).offset(8)
        }
        
        priceLab.snp.makeConstraints{
            $0.right.equalTo(imgv.snp.right).offset(-8)
            $0.top.equalTo(imgv.snp.bottom).offset(8)
        }
        
        descLab.snp.makeConstraints{
            $0.left.equalTo(titleLab.snp.left)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.top.equalTo(titleLab.snp.bottom).offset(8)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.groupTableViewBackground
        addSubview(line)
        
        line.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
