//
//  CategoryHeaderCollectionReusableView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CategoryHeaderCollectionReusableView: UICollectionReusableView {
    
    var titleLab:UILabel = {
       let lab = UILabel()
        lab.text = "Category"
        lab.textColor = .black
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.textAlignment = .center
        lab.backgroundColor = .white
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let line = UIView()
        line.backgroundColor = UIColor.gray
        
        addSubview(line)
        addSubview(titleLab)
        
        line.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(200)
        }
        
        titleLab.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(120)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
