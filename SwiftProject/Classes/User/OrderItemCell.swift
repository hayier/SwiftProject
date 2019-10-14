//
//  OrderItemCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class OrderItemCell: UITableViewCell {

    
    @IBOutlet weak var orderNumLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var action1Btn: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var spaceHeight: NSLayoutConstraint!
    
    var selectedCell:(()->Void)?
    
    var items:[ProductSnapListItem] = [ProductSnapListItem](){
        didSet{
            tableViewHeight.constant = CGFloat(items.count * 110)
            tableView.reloadData()
        }
    }
    
    var order:Order!{
        didSet{
            orderNumLab.text = "订单编号：" + order.OrderNo
            statusLab.text = order.OrderState
            if order.OrderState == "已完成" || order.OrderState == "已取消"{
                statusLab.textColor = .black
                action1Btn.isHidden = true
                actionBtn.setTitle("联系客服", for: .normal)
            }else if order.OrderState == "待支付"{
                statusLab.textColor = .HRed
                action1Btn.isHidden = false
                action1Btn.setTitle("联系客服", for: .normal)
                actionBtn.setTitle("去支付", for: .normal)
            }else if order.OrderState == "待发货"{
                statusLab.textColor = .HRed
                action1Btn.isHidden = false
                action1Btn.setTitle("申请退款", for: .normal)
                actionBtn.setTitle("联系客服", for: .normal)
            }else if order.OrderState == "已发货"{
                statusLab.textColor = .HRed
                action1Btn.isHidden = false
                action1Btn.setTitle("申请退款", for: .normal)
                actionBtn.setTitle("确认收货", for: .normal)
            }else if order.OrderState == "已退款"{
                statusLab.textColor = .HRed
                actionBtn.setTitle("联系客服", for: .normal)
                action1Btn.isHidden = true
            }else{
                actionBtn.setTitle("联系客服", for: .normal)
                action1Btn.isHidden = true
            }
    
            desLab.text = "共\(order.ProductCnt)件商品，实付款 ￥" + String(format: "%.2f", order.PayPrice)
        }
    }
    
    let cellId = "OrderItemProductCell"
    
    var btnAction:((_ btn:UIButton)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        selectionStyle = .none
        
        tableView.isScrollEnabled = false
        tableView.rowHeight = 110
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "OrderItemProductCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        layerBtn(btn: actionBtn)
        layerBtn(btn: action1Btn)
    }
    
    func layerBtn(btn:UIButton){
        btn.layer.cornerRadius = 12.5
        btn.layer.borderColor = UIColor.HTextBlack.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(btn_action(btn:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func btn_action(btn:UIButton){
        if let action = btnAction {
            action(btn)
        }
    }
    
}

extension OrderItemCell:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderItemProductCell
        let model = items[indexPath.row]
        cell.imgv.kf.setImage(with: model.Main_img.imgRequestUrl)
        cell.nameLab.text = model.ProductName
        cell.priceLab.text = String(format: "￥%.2f", model.BuyPrice)
        cell.standardsLab.text = "规格：" + model.ProductDetiles
        cell.countLab.text = "x\(model.GetCnt)"
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension OrderItemCell:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedCell = self.selectedCell {
            selectedCell()
        }
        
    }
}
