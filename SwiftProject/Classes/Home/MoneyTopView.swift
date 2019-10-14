//
//  MoneyTopView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/20.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SnapKit

class MoneyTopView: UIView {

    let lab1:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.darkText
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        return lab
    }()
    
    let lab2:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.darkText
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        return lab
    }()
    
    let sureBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.backgroundColor = .black
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    var sureBtnWidthConstraint:Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgv = UIImageView()
        addSubview(imgv)
        imgv.image = #imageLiteral(resourceName: "mine_team_bg")
        
        addSubview(lab1)
        addSubview(lab2)
        addSubview(sureBtn)
        
        
        imgv.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        lab1.snp.makeConstraints{
            $0.left.equalTo(8)
            $0.centerY.equalToSuperview()
        }
        
        lab2.snp.makeConstraints{
            $0.left.equalTo(lab1.snp.right).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        sureBtn.snp.makeConstraints{
            $0.right.equalTo(-20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
            self.sureBtnWidthConstraint = $0.width.equalTo(65).constraint
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
