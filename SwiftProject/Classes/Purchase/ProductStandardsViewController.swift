//
//  ProductStandardsViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SnapKit

class ProductStandardsViewController: UIViewController {

    let backView:UIView = {
        let t = UIView()
        t.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        t.alpha = 0
        return t
    }()
    
    let contentV = Bundle.main.loadNibNamed("ProductStardardsContentView", owner: nil, options: nil)?.first as! ProductStardardsContentView
    var bottomConstraint: Constraint?

    var completion:((Bool) -> Void)?
    
    let cellId = "StandardsCell"
    
    var attrArr:[ProductAttrGroupItem]?
    var valueArr:[ProductAttrValueItem]?{
        didSet{
            self.contentV.collectionView.reloadData()
        }
    }
    var product:Product?{
        didSet{
            //默认使用product
            contentV.imgv.kf.setImage(with: product?.ProductImg.imgRequestUrl)
            contentV.nameLab.text = product?.ProductName
            contentV.priceLab.text = "￥\(product!.Price)"
        }
    }
    
    var selectedValue:ProductAttrValueItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(backView)
        
        view.addSubview(contentV)
        contentV.backgroundColor = .white
        contentV.layer.cornerRadius = 20
        
        layoutViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backView.addGestureRecognizer(tap)
        
        contentV.collectionView.delegate = self
        contentV.collectionView.dataSource = self
        
        contentV.collectionView.register(StandardsCell.self, forCellWithReuseIdentifier: cellId)
    }

    func layoutViews(){
        
        backView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        //固定height
        let height = UIScreen.main.bounds.size.height * 0.65
        contentV.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.height.equalTo(height)
            //增加弧度
            self.bottomConstraint = $0.bottom.equalTo(contentV.layer.cornerRadius).constraint
            $0.top.equalTo(view.snp.bottom).priority(.low)
        }
        

        //在布局生成之后再操作(是否走完makeConstraints) 否则无效
        self.bottomConstraint?.deactivate()
        
    }
    
    func refreshData(idxPath:IndexPath){
        let value = valueArr![idxPath.item]
        for attr in attrArr! {
            if attr.ID == value.GroupID{
                contentV.imgv.kf.setImage(with: attr.StgPic.imgRequestUrl)
                contentV.priceLab.text = "￥\(attr.Price)"
            }
        }
    }

    func showView(){
        backView.alpha = 0
        view.bringSubviewToFront(contentV)
        self.bottomConstraint?.activate()
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (b) in }
    }

    @objc func dismissView(){
        self.bottomConstraint?.deactivate()
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (b) in
            if let c = self.completion {
                c(b)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = contentV.collectionView.contentSize.height
        if height >= 400 {
            contentV.collectionViewHeight.constant = 400
        }else{
            contentV.collectionViewHeight.constant = height
        }
    }
}

extension ProductStandardsViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //更新数据
        refreshData(idxPath: indexPath)
        selectedValue = valueArr![indexPath.item]
    }
}

extension ProductStandardsViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let arr = valueArr else {
            return 0
        }
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellId, for: indexPath) as! StandardsCell
        cell.nameLab.text = valueArr![indexPath.row].AttrValue
        cell.isSelected = false
        return cell
    }
}

extension ProductStandardsViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lab = UILabel()
        lab.text = valueArr![indexPath.item].AttrValue
        let width = lab.sizeThatFits(CGSize.zero).width + 30
        return CGSize(width: width, height: 30.0)
    }
}
