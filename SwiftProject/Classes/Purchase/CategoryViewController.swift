//
//  CategoryViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/9.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController {

    let cateCollectionVC = CategoryChildViewController()
    let tableView:UITableView = {
        let t = UITableView()
        t.separatorStyle = .none
        t.showsVerticalScrollIndicator = false
        t.backgroundColor = UIColor.HBackGray
        t.rowHeight = 65
        t.allowsSelection = true
        return t
    }()
    
    let cateImgv:UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        v.image = UIImage(named: "home_img1")
        return v
    }()
    
    let topView = SearchTopView()
    
    let cellId = "CateColmCell"
    
    var productData:ProductDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CateColmCell.self, forCellReuseIdentifier: cellId)
        
        layoutViews()
        
        topView.btn.addTarget(self, action: #selector(searchTap), for: .touchUpInside)
        
        getData()
    }
    
    func layoutViews(){
        addChild(cateCollectionVC)
        view.addSubview(cateCollectionVC.view)
        
        view.addSubview(cateImgv)
        
        view.addSubview(topView)
        
        topView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.height.equalTo(65)
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
        
        tableView.snp.makeConstraints{
            $0.left.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalTo(100)
        }
        
        cateCollectionVC.view.snp.makeConstraints{
            $0.left.equalTo(tableView.snp.right)
            $0.bottom.right.equalToSuperview()
            $0.top.equalTo(cateImgv.snp.bottom).offset(10)
        }
        
        let width = self.view.frame.width - 125
        let height = width * 0.5
        cateImgv.snp.makeConstraints{
            $0.left.equalTo(tableView.snp.right).offset(20)
            $0.right.equalTo(-5)
            $0.top.equalTo(topView.snp.bottom)
            $0.height.equalTo(height)
        }
    }
    
    @objc func searchTap(){
        let vc = ProductListViewController()
        show(vc, sender: nil)
    }
}

extension CategoryViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CategoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        if(indexPath.row == 0){
            cateCollectionVC.cate = -1;
            cateImgv.image = UIImage(named: "home_img1");
            return;
        }
        cateCollectionVC.cate = productData!.ProductType![indexPath.row - 1].ID
        cateImgv.kf.setImage(with: productData?.ProductType[indexPath.row - 1].TypeImg.imgRequestUrl, placeholder: UIImage(named: "home_img1"))
    }
}

extension CategoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = productData?.ProductType else {
            return 0
        }
        return type.count + 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CateColmCell
        if(indexPath.row == 0){
            cell.nameLab.text = "全部";
        }else{
            cell.nameLab.text = productData?.ProductType[indexPath.row - 1].TypeName
        }
        cell.isSelected = false
        return cell
    }
}

extension CategoryViewController{
    
    func getData(){
        
        HRequest.getCacheData(api: API.GetGoodsType) { (data) in
            self.productData = ProductDataModel.deserialize(from: data.rawString())
            self.cateCollectionVC.productArr = self.productData?.ProductInfo
            self.tableView.reloadData()
            
            self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            //self.cateCollectionVC.cate = self.productData?.ProductType.first?.ID ?? 0
        }
    }
    
    
}
