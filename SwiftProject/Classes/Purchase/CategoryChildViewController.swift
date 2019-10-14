//
//  CategoryChildViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/9.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CategoryChildViewController: UIViewController {

    let inset:CGFloat = 25
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 5)
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = .white
        return c
    }()
    
    let cellId = "CateProductCell"
    
    var cate = 0{
        didSet{
            filterData()
        }
    }
    
    //总产品数据
    var productArr:[ProductInfoItem]?
    //筛选后数据
    var products:[ProductInfoItem]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CateProductCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
    
    func filterData(){
        
        guard let arr = productArr else {
            return
        }
        
        if cate == -1 {
            self.products = arr;
            return;
        }
        
        let products = arr.filter{
            return $0.TypeId == cate
        }
        
        self.products = products
        
    }
    
    
}

extension CategoryChildViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ProductDetailViewController()
        vc.productId = products![indexPath.item].ProductID
        show(vc, sender: nil)
    }
}

extension CategoryChildViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - inset - 20)/3
        let height = width + 30
        return CGSize(width: width, height: height)
    }
    
}

extension CategoryChildViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let p = products else {
            return 0
        }
        return p.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CateProductCell
        cell.imgv.kf.setImage(with:products![indexPath.item].ProductImg.imgRequestUrl)
        cell.nameLab.text = products![indexPath.item].ProductName
        return cell
    }
}
