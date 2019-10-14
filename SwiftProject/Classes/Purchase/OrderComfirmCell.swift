//
//  OrderComfirmCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/8.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderComfirmCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var p_priceLab: UILabel!
    @IBOutlet weak var ep_priceLab: UILabel!
    @IBOutlet weak var od_priceLab: UILabel!
    @IBOutlet weak var count_priceLab: UILabel!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var spaceHeight: NSLayoutConstraint!
    
    var count:Int = 0{
        didSet{
            tableViewHeight.constant = CGFloat(count * 100)
        }
    }
    
    let cellId = "OrderItemProductCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //contentView.backgroundColor = UIColor.groupTableViewBackground
        
        tableView.allowsSelection = false
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "OrderItemProductCell", bundle: nil), forCellReuseIdentifier: cellId)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension OrderComfirmCell:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderItemProductCell
        return cell
    }
    
    
}

extension OrderComfirmCell:UITableViewDelegate{
    
    
}


