//
//  LeftFirstCollectionLayout.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/8.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class LeftFirstCollectionLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrArr = super.layoutAttributesForElements(in: rect)
        guard let arr = attrArr else{return nil}
        let ocArr = NSArray(array: arr)
        let ocCopyArr = NSArray.init(array: ocArr)
        let ocCArr = NSArray(array: ocCopyArr as! [UICollectionViewLayoutAttributes], copyItems: true)
        
        let copyArr = ocCArr as! [UICollectionViewLayoutAttributes]
        for attr in copyArr{
            if attr.representedElementKind == nil{
                if let a = layoutAttributesForItem(at: attr.indexPath){
                    attr.frame = a.frame
                }
            }
        }
        return copyArr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let pattr = super.layoutAttributesForItem(at: indexPath)
        guard let attr = pattr else{return nil}
        guard let colView = self.collectionView else{ return nil}
        if let flowLayout = colView.collectionViewLayout as? UICollectionViewFlowLayout{
            let inset = flowLayout.sectionInset
            if indexPath.item == 0 {
                var frame = attr.frame
                frame.origin.x = inset.left
                attr.frame = frame
                return attr;
            }
            let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            guard let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame else{ return nil }
            
            let ispace = flowLayout.minimumInteritemSpacing
            let lspace = flowLayout.minimumLineSpacing
            
            var left = previousFrame.origin.x + previousFrame.size.width + ispace
            var y = previousFrame.origin.y
            var frame = attr.frame;
    
            //判断是否超过宽度
            let maxRight = left + frame.size.width + inset.right
            
            
            if maxRight > colView.frame.size.width{
                left = 0
                y = previousFrame.maxY + lspace
            }else{
                frame.origin.x = left
            }
            
            frame.origin.x = left
            frame.origin.y = y
            attr.frame = frame
            return attr
        }
        return nil
    }
    
}
