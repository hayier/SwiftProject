//
//  ProductDetailModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/29.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON

struct Product: HandyJSON {
    var ProductID: Int = 0
    var TypeId: Int = 0
    var ProductNumber: String!
    var ProductName: String!
    var ProductImg: String!
    var Price: Float = 0
    var AddTime: String!
    var States: String!
    var ImgTxtContent: String!
    var ImgTxtTmp: String!
    var MStock: Int = 0
    var Recommend: Int = 0
    var IsWxBus: Bool = false
    var IsMall: Bool = false
    var Freight: Float = 0
    var ProductDetiles: String!
    var ProductDetilesHtml: String!
    var TotalRowsInTable: Int = 0
    var getcnt: Int = 0
    var buyprice: Float = 0
    var GroupID: Int = 0
}

struct ProductAttrGroupItem : HandyJSON {
    var ID: Int = 0
    var ProductID: Int = 0
    var SetKeyId: String!
    var Stock: Int = 0
    var Price: Float = 0
    var StgPic: String!
    var IsDefault: Bool = false
}

struct ProductAttrValueItem    : HandyJSON {
    var ID: Int = 0
    var AttrKeyID: Int = 0
    var AttrName: String!
    var AttrValue: String!
    var ProductID: Int = 0
    var GroupID: Int = 0
    var Sort: Int = 0
}

struct ProductDetailData : HandyJSON {
    var productAttrGroup: [ProductAttrGroupItem]!
    var productAttrValue: [ProductAttrValueItem]!
    var cnt: Int = 0
    var product:Product!
}
