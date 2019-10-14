//
//  OrderItemProductCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderItemProductCell: UITableViewCell {

    
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var standardsLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var countLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
