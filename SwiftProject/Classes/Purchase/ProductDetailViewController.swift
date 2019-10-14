//
//  ProductDetailViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast

class ProductDetailViewController: UIViewController {

    let tableView:UITableView = {
        let t = UITableView()
        t.backgroundColor = .white
        t.allowsSelection = false
        t.separatorStyle = .none
        t.estimatedRowHeight = 300
        return t
    }()
    
    let cellId = "LongImgViewCell"
    
    let bottomView = ProductDetailBottomView()
   
    let standardsVC = ProductStandardsViewController()
    
    var attrArr = [ProductAttrGroupItem]()
    var valueArr = [ProductAttrValueItem]()
    var product:Product?{
        didSet{
            detailImgs = product?.ImgTxtContent.getRegexJPG() ?? [String]()
            self.tableView.reloadData()
        }
    }
    var productCnt:Int = 0
    
    var detailImgs:[String] = [String]()
    
    var productId:Int?{
        didSet{
            //getData()
            //self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defer{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {[unowned self] in
                self.tableView.reloadData()
            }
        }
        
        title = "产品详情"
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LongImgViewCell.self, forCellReuseIdentifier: cellId)
        
        layoutViews()
        
        addChild(standardsVC)
        view.addSubview(standardsVC.view)
        standardsVC.view.frame = view.bounds
        view.layoutIfNeeded()
        standardsVC.view.isHidden = true
        
        bottomView.cartBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        bottomView.buyBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        bottomView.shopImgBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        
        standardsVC.contentV.sureBtn.addTarget(self, action: #selector(sureAction(sender:)), for: .touchUpInside)
        
        getData()
    }
    
    func layoutViews(){

        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            
        }
        
        bottomView.snp.makeConstraints{
            $0.bottom.left.right.equalToSuperview()
            if UIApplication.shared.statusBarFrame.height > 30 {
                $0.height.equalTo(68)
            }else{
                $0.height.equalTo(48)
            }
        }
    }
    
    func fillProductView(){
        
        guard let model = product else {
            return
        }
        let str = model.ProductName
        let header = ProductDetailHeaderView(frame:view.bounds)
        header.title = str ?? ""
        header.serverImages = [model.ProductImg.imgRequestString!]
        header.priceLab.text = "￥\(model.Price)"
        header.expressLab.text = "￥\(model.Freight)"
        
        //需要计算高度来设置header高度
        let width = view.frame.size.width
        let height = view.frame.size.width + header.titleHeight + 85
        header.frame = CGRect(x: 0, y: 0, width:width, height:height)
        tableView.tableHeaderView = header
        
    }
    
    @objc func btnAction(btn:UIButton){
        
        switch btn {
        case bottomView.cartBtn:
            showStandardView()
            standardsVC.contentV.sureBtn.setTitle("加入购物车", for: .normal)
            standardsVC.completion = {[unowned self] (b) in
                self.standardsVC.view.isHidden = true
            }
        case bottomView.buyBtn:
            showStandardView()
            standardsVC.contentV.sureBtn.setTitle("立即购买", for: .normal)
        case bottomView.shopImgBtn:
            let vc = ShopCartViewController()
            show(vc, sender: nil)
        default:
            return
        }
        
        
    }
    
    func showStandardView(){
        standardsVC.view.isHidden = false
        standardsVC.showView()
        standardsVC.completion = {[unowned self] (b) in
            self.standardsVC.view.isHidden = true
        }
    }
    
    @objc func sureAction(sender:UIButton){
        
        guard let _ = UserHelper.UserKey.getValue else {
            //未登录
            UserHelper.showLogin()
            return
        }
        guard let value = standardsVC.selectedValue else {
            self.view.makeToast("未选择规格", duration: 1.0, position: CSToastPositionCenter)
            return
        }
        
        guard let cnt = Int(standardsVC.contentV.tf.text ?? "1") else { return }
        
        guard let title = sender.currentTitle else{ return }
        
        standardsVC.dismissView()
        
        if title == "加入购物车"{
            addToCart(cnt: cnt, value: value)
        }else{
            
            guard let group = (attrArr.first{
                return value.GroupID == $0.ID
            }) else{
                self.view.makeToast("没有Group ID 不能购买", duration: 1.0, position: CSToastPositionCenter)
                return
            }
            
            let vc = OrderConfirmViewController()
            vc.buyType = .mail
            vc.mailParams = (cnt, group, value, product!)
            show(vc, sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        
    }
  
}

extension ProductDetailViewController:UITableViewDelegate{
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
    
}

extension ProductDetailViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailImgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LongImgViewCell
        cell.imgv.kf.setImage(with: detailImgs[indexPath.row].imgRequestUrl, placeholder: UIImage(named: "color_icon")) { [weak self] (img, error, type, url) in
            if(error == nil){
                cell.adjustImage()
                if type == .none {
                    self?.tableView.reloadData()
                }
            }
        }
        return cell
    }
    
}


extension ProductDetailViewController{
    
    func getData(){
        guard let Id = productId else {
            return
        }

        let api = API.GetGoodsDetail(id:Id)
        
        HRequest.getCacheData(api: api) {
            
            //处理valueArr
            guard let pmodel = ProductDetailData.deserialize(from:$0.rawString()) else{
                return
            }
            
            self.product = pmodel.product
            self.productCnt = pmodel.cnt
            
            let defaultValue = ProductAttrValueItem(ID: 0, AttrKeyID: 0, AttrName:"规格" , AttrValue: pmodel.product.ProductDetiles , ProductID: pmodel.product.ProductID, GroupID: pmodel.product.GroupID, Sort: 0)
            let defaultGrop = ProductAttrGroupItem(ID: 0, ProductID: pmodel.product.ProductID, SetKeyId: "1", Stock: pmodel.product.MStock, Price: pmodel.product.Price, StgPic: pmodel.product.ProductImg, IsDefault: true)
            self.valueArr.append(defaultValue)
            self.valueArr.append(contentsOf: pmodel.productAttrValue)
            self.attrArr.append(defaultGrop)
            self.attrArr.append(contentsOf: pmodel.productAttrGroup)
            
            self.fillProductView()
            
            self.standardsVC.attrArr = self.attrArr
            self.standardsVC.valueArr = self.valueArr
            self.standardsVC.product = self.product
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func addToCart(cnt:Int,value:ProductAttrValueItem){
  
        let api = API.AddToCart(key: UserHelper.UserKey.getValue!, ProductID: standardsVC.selectedValue!.ProductID, GetCnt: cnt, GroupID: standardsVC.selectedValue!.GroupID)
        
        HRequest.getData(api: api) { (data) in
            self.view.makeToast("已加入购物车", duration: 1.0, position: CSToastPositionCenter)
        }
        
    }

}
