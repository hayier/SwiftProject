//
//  MoneyManageCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class MoneyManageCell: UITableViewCell {

    
    @IBOutlet weak var kindLab: UILabel!
    @IBOutlet weak var moneyLab: UILabel!
    @IBOutlet weak var leftLab: UILabel!
    @IBOutlet weak var rightLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
