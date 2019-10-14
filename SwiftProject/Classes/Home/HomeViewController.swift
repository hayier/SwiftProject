//
//  HomeViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/6.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomeViewController: UIViewController {

    let collectionView:UICollectionView = {
       let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.showsVerticalScrollIndicator = false
        c.backgroundColor = .white
        return c
    }()
    
    let topView = SearchTopView()
    
    let cellId = "SingleImgCell"
    let cell_banner_Id = "cell_banner_Id"
    let headerId = "SingleImgCell"
    
    var sectionArr:[ProductTypeItem]?
    var rowArr:[ProductInfoItem]?
    var dataArr = [[ProductInfoItem]]()
    var bannerItems = [ProductInfoItem]()
    
    lazy var retryBtn:UIButton = {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.setTitle("重新请求", for: .normal)
        $0.setTitleColor(.HBlue, for: .normal)
        return $0
    }(UIButton())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImageCycleCell.self, forCellWithReuseIdentifier: cell_banner_Id)
        collectionView.register(SingleImgCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CategoryHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        layoutViews()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        topView.btn.addTarget(self, action: #selector(searchClick), for: .touchUpInside)
        
        getData()
        
        isfirestIn()
    }
    
    func layoutViews(){
        view.addSubview(collectionView)
        
        view.addSubview(topView)
        
        collectionView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            }
        }
        
        topView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.height.equalTo(65)
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
    }
    
    @objc func searchClick(){
        
        let vc = ProductListViewController()
        show(vc, sender: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
//        let isLogin = UserHelper.isLogin.getValue
//        if isLogin == "0" || isLogin == nil{
//            UserHelper.showLogin()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
}

extension HomeViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let count = sectionArr?.count else {
            return 0
        }
        return count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataArr[section-1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let idx = IndexPath(item: 0, section: 0)
        if indexPath == idx {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_banner_Id, for: indexPath) as! ImageCycleCell
            cell.bannerArr = self.bannerItems
            cell.selectedProduct = {[unowned self] (item) in
                let vc = ProductDetailViewController()
                vc.productId = item.ProductID
                self.show(vc, sender: nil)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleImgCell
            let imgUrl = dataArr[indexPath.section-1][indexPath.row].ProductImg.imgRequestUrl
            cell.imgv.kf.setImage(with: imgUrl)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! CategoryHeaderCollectionReusableView
        let idx = IndexPath(item: 0, section: 0)
        if indexPath != idx {
            guard let secArr = sectionArr else{
                return header
            }
            header.titleLab.text = secArr[indexPath.section-1].TypeName
        }
        return header
    }
    
}

extension HomeViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let idx = IndexPath(item: 0, section: 0)
        if idx == indexPath {return}
        let models = dataArr[indexPath.section-1]
        //let cateName = sectionArr?[indexPath.section-1].TypeName
        let vc = ProductDetailViewController()
        vc.productId = models[indexPath.item].ProductID
        show(vc, sender: nil)
    }
    
}

extension HomeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.view.frame.size.width
        if section == 0 {
            return CGSize(width: width, height: 0)
        }else{
            return CGSize(width:width,height:80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let idx = IndexPath(item: 0, section: 0)
        if indexPath == idx {
            let height = 200/345 * self.view.frame.width
            return CGSize(width:self.view.frame.size.width, height: height)
        }
        let height = 156/345 * (self.view.frame.width)
        return CGSize(width:self.view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension HomeViewController{
    
    func getData(){
        
        UIView.show(message: "加载中...")
        HRequest.getCacheData(api: API.GetProducAll){
            
            UIView.dismiss(delay: 0, completion: {
                
            })
            
            let dataModel = ProductDataModel.deserialize(from: $0.rawString())
            
            guard let rowArr = dataModel?.ProductInfo else {
                return
            }
            guard let typeArr = dataModel?.ProductType else {
                return
            }
            
            self.sectionArr = typeArr
            self.rowArr = rowArr
            
            var dArr = [[ProductInfoItem]]()
            let _ = typeArr.map{ (typeItem) in
                let fArr =  rowArr.filter{
                    return $0.TypeId == typeItem.ID
                }
                dArr.append(fArr)
            }
            self.dataArr = dArr
            let RecommendArr = rowArr.filter{$0.Recommend == 1}
            self.bannerItems = RecommendArr
            
            self.collectionView.reloadData()
        }
        
    }
    
}

extension HomeViewController {
    
    //初次进入无网络解决方案
    //判断是否第一次进入
    func isfirestIn(){
        
        func addRretryBtn(){
            
            self.view.addSubview(retryBtn)
            self.view.bringSubviewToFront(retryBtn)
            
            retryBtn.snp.makeConstraints{
                $0.center.equalToSuperview()
            }
            
            retryBtn.addTarget(self, action: #selector(retryRequest), for: .touchUpInside)
        }
        
        
        if let _ = UserDefaults.standard.value(forKey: "the_first_in") as? Int{
            //如果已经进入过,有网络缓存，不做处理
        }else{
            //第一次进入网络无法请求，
            //解决方案：放入重新请求按钮
            UserDefaults.standard.set(1, forKey: "the_first_in")
            UserDefaults.standard.synchronize()
            
            //是否有网络
            if let reach = NetworkReachabilityManager() {
                if !reach.isReachable{
                    addRretryBtn()
                }
            }

        }
        
        
        
    }
    
    @objc func retryRequest(){
        
        if let reach = NetworkReachabilityManager() {
            if reach.isReachable{
                retryBtn.isHidden = true
                retryBtn.removeFromSuperview()
                
                 getData()
            }else{
                view.toast(message: "网络错误")
            }
        }
       
       
        
    }
    
}
