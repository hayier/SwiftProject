//
//  SearchTopView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class SearchTopView: UIView {

    let btn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "home_searchfor"), for: .normal)
        btn.setTitle("请输入你需要搜索的内容", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(.HTextGray, for: .normal)
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .HBackGray
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(btn)
        
        btn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.height.equalTo(35)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


class SearchTopTFView: UIView {
    
    let tf:UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入需要搜索的内容"
        let imgv = UIImageView(image: UIImage(named: "home_searchfor"))
        imgv.contentMode = .scaleAspectFit
        imgv.snp.makeConstraints{
            $0.width.equalTo(40)
            $0.height.equalTo(20)
        }
        tf.leftView = imgv
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.HGray.cgColor
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.backgroundColor = UIColor.HBackGray
        tf.leftViewMode = .always
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tf)
        
        tf.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.height.equalTo(35)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
