//
//  AddressCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/6.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    @IBOutlet weak var addressLab: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editBtn.setImage(UIImage(named: "address_icon2"), for: .normal)
        
        editBtn.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
    }
    
    @objc func edit(){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.Address.edit"), object: self)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
