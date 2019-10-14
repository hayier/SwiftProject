//
//  ImageCycleCell.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ImageCycleCell: UICollectionViewCell {
    
    
    var cycleScrollView:WRCycleScrollView?
    // 可加载网络图片或者本地图片
    var bannerArr = [ProductInfoItem](){
        didSet{
            let imgs = bannerArr.compactMap{$0.ProductImg.imgRequestUrl?.absoluteString}
            cycleScrollView?.serverImgArray = imgs
        }
    }
    
    var selectedProduct:((_ item:ProductInfoItem)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgs = bannerArr.compactMap{$0.ProductImg.imgRequestUrl?.absoluteString}
        cycleScrollView = WRCycleScrollView(frame:.zero, type: .SERVER, imgs: imgs)
        guard let cycle = cycleScrollView else {
            return
        }
        contentView.addSubview(cycle)
        cycle.delegate = self
        cycle.frame = frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        cycle.layer.cornerRadius = 10
        cycle.autoScrollInterval = 3
        cycle.currentDotColor = .black
        cycle.otherDotColor = .white
        cycle.clipsToBounds = true
        
        cycle.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.top.equalTo(5)
            $0.bottom.equalTo(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageCycleCell: WRCycleScrollViewDelegate
{
    /// 点击图片事件
    func cycleScrollViewDidSelect(at index:Int, cycleScrollView:WRCycleScrollView)
    {
        if let sp = selectedProduct {
            sp(bannerArr[index])
        }
    }
    
    /// 图片滚动事件
    func cycleScrollViewDidScroll(to index:Int, cycleScrollView:WRCycleScrollView)
    {
        
    }
}
