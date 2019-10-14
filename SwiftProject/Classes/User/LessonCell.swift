//
//  LessonCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var cellBtn: UIButton!
    
    var see:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        imgv.layer.cornerRadius = 10
        
        cellBtn.backgroundColor = .HBlue
        cellBtn.layer.cornerRadius = 10
        cellBtn.clipsToBounds = true
        cellBtn.addTarget(self, action: #selector(seeVideo), for: .touchUpInside)
        
    }
    
    @objc func seeVideo(){
        guard let action = see else{return}
        action()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
