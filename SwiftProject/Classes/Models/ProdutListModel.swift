//
//  ProdutModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/28.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON

struct ProductInfoItem : HandyJSON {
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
    var Freight: Int = 0
    var ProductDetiles: String!
    var ProductDetilesHtml: String!
    var TotalRowsInTable: Int = 0
    var getcnt: Int = 0
    var buyprice: Int = 0
    var GroupID: Int = 0
}

struct ProductTypeItem : HandyJSON {
    var ID: Int = 0
    var ParentID: Int = 0
    var TypeName: String!
    var AttrIDSet: String!
    var Status: Int = 0
    var TypeImg: String!
    var CreatDate: String!
    var UpdateDate: String!
    var TotalRowsInTable: Int = 0
}

struct ProductDataModel : HandyJSON {
    var ProductInfo: [ProductInfoItem]!
    var ProductType: [ProductTypeItem]!
}

struct CommonModel : HandyJSON {
    var _code: Int = 0
    var _timestamp: Int = 0
    var _pages: Int = 0
    var _total: Int = 0
    var _message: String!
    var _success: Bool = false
}

