//
//  ProductListViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductListViewController: UIViewController {

    let collectionView:UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.backgroundColor = .white
        return c
    }()
    
    let cellId = "ProductListCell"
    
    let topSearchView = SearchTopTFView()
    
    var models = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "产品列表"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(topSearchView)
        
        view.addSubview(collectionView)
        
        topSearchView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.height.equalTo(65)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(topSearchView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        topSearchView.tf.addTarget(self, action: #selector(search(tf:)), for: .editingDidEnd)
        topSearchView.tf.returnKeyType = .search
        topSearchView.tf.delegate = self
     
        getData()
        
    }
    
    @objc func search(tf:UITextField){
        
        if let str = tf.text{
            queryProduct(str: str)
        }
        
    }

}

extension ProductListViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        search(tf: textField)
        
        textField.resignFirstResponder()
        
        return false
    }
    
}


extension ProductListViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductListCell
        let model = models[indexPath.item]
        cell.imgv.kf.setImage(with: model.ProductImg.imgRequestUrl)
        cell.nameLab.text = model.ProductName
        cell.priceLab.text = "\(model.Price)"
        return cell
        
    }
    
}

extension ProductListViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.item]
        let vc = ProductDetailViewController()
        vc.productId = model.ProductID
        show(vc, sender: nil)
    }
   
}

extension ProductListViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 30)*0.5
        let height = width * 1.33
        return CGSize(width:width,height:height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
    }
    
}


extension ProductListViewController{
    func getData(){
        HRequest.getCacheData(api: API.GetProducAll){

            let ProductInfos = $0["ProductInfo"].arrayValue
            for p in ProductInfos {
                guard let model = Product.deserialize(from: p.rawString()) else{
                    break
                }
                self.models.append(model)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func queryProduct(str:String){
        
        let api = API.ProducTypeName(typename:str)
        
        HRequest.getData(api: api) {
            let ProductInfos = $0.arrayValue
            var arr = [Product]()
            for p in ProductInfos {
                guard let model = Product.deserialize(from: p.rawString()) else{
                    break
                }
                arr.append(model)
            }
            self.models = arr
            self.collectionView.reloadData()
        }
    }
    
}
