//
//  TeamCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var idLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgv.layer.cornerRadius = 25
        imgv.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
