//
//  ProductDetailHeaderView.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/7.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class ProductDetailHeaderView: UIView {

    // 可加载网络图片或者本地图片
    var serverImages:[String]?{
        didSet{
            cycleView?.serverImgArray = serverImages
        }
    }
    
    var cycleView:WRCycleScrollView?
    let line = UIView()
    let priceLab = UILabel()
    let expressLab = UILabel()
    let titleLab = UILabel()
    let content = UIView()
    
    let width = UIScreen.main.bounds.size.width - 20
    
    var title:String = "这是一件商品"{
        didSet{
            let attrStr = NSMutableAttributedString(string: title)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            let range = NSRange(location: 0, length: title.count)
            attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
            titleLab.attributedText = attrStr
            titleHeight = titleLab.sizeThatFits(CGSize(width: width, height: 0)).height
        }
    }
    var titleHeight:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        //let insert = frame.size.width
        //let f = CGRect(x: 0, y: 0, width: insert, height: insert)
        //这个cycle会计算获取父视图的大小来布局
        addSubview(content)
        
        cycleView = WRCycleScrollView(frame:.zero, type: .SERVER, imgs: serverImages)
        guard let cycle = cycleView else {
            return
        }
        content.addSubview(cycle)
        cycle.delegate = self
        cycle.isAutoScroll = false
        cycle.currentDotColor = .black
        cycle.otherDotColor = .white

        addSubview(line)
        line.backgroundColor = UIColor.groupTableViewBackground
        
        addSubview(priceLab)
        priceLab.font = UIFont.boldSystemFont(ofSize: 17)
        priceLab.text = "￥23"
        
        addSubview(expressLab)
        expressLab.text = "快递费：￥10.00"
        expressLab.font = UIFont.systemFont(ofSize: 13)
        
        addSubview(titleLab)
        titleLab.numberOfLines = 0
    
        cycle.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        content.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(content.snp.width)
        }
        
        line.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(content.snp.bottom)
            $0.height.equalTo(1)
        }
        
        priceLab.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }
        
        expressLab.snp.makeConstraints{
            $0.right.equalTo(-10)
            $0.centerY.equalTo(priceLab.snp.centerY)
        }
        
        titleLab.snp.makeConstraints{
            $0.width.equalTo(width)
            $0.left.equalTo(10)
            $0.top.equalTo(priceLab.snp.bottom).offset(5)
        }
        
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.groupTableViewBackground
        let shortLine = UIView()
        shortLine.backgroundColor = UIColor.gray
        let detailSectionLab = UILabel()
        detailSectionLab.text = "宝贝详情"
        detailSectionLab.backgroundColor = UIColor.groupTableViewBackground
        detailSectionLab.textColor = .gray
        detailSectionLab.textAlignment = .center
        
        addSubview(sectionView)
        sectionView.addSubview(shortLine)
        sectionView.addSubview(detailSectionLab)
        
        sectionView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titleLab.snp.bottom).offset(8)
            $0.height.equalTo(40)
        }
        
        shortLine.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(120)
        }
        
        detailSectionLab.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(80)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cycleView?.frame = content.frame
    }
    
}



extension ProductDetailHeaderView: WRCycleScrollViewDelegate
{
    /// 点击图片事件
    func cycleScrollViewDidSelect(at index:Int, cycleScrollView:WRCycleScrollView)
    {
        //print("点击了第\(index+1)个图片")
    }
    
    /// 图片滚动事件
    func cycleScrollViewDidScroll(to index:Int, cycleScrollView:WRCycleScrollView)
    {
        //print("滚动到了第\(index+1)个图片")
    }
}
