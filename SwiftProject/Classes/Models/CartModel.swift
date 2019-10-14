//
//  CartModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/31.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON

struct CartDataItem    : HandyJSON {
    var ProductNumber: String!
    var ProductName: String!
    var ProductImg: String!
    var States: String!
    var Price: Float = 0
    var Price_agent: Int = 0
    var attrvalue: String!
    var attr_price: Float = 0
    var ID: Int = 0
    var C_UserName: String!
    var GoodsID: Int = 0
    var GetCnt: Int = 0
    var IsCheck: Bool = false
    var IsCloud: Bool = false
    var CartType: Int = 0
    var GroupID: Int = 0
    var TotalRowsInTable: Int = 0
}

struct AttrValueModel    : HandyJSON {
    var AttrName: String!
    var AttrValue: String!
    var ID: Int = 0
    var ProductID: Int = 0
    var SetKeyId: String!
    var Stock: Int = 0
    var Price: Float = 0
    var StgPic: String!
    var IsDefault: Bool = false
    var CreatDate: String!
    var UpdateDate: String!
    var TotalRowsInTable: Int = 0
}


struct GoodsVMsItem : HandyJSON {
    var cnt: Int = 0
    var mAttrValue:AttrValueModel?
    var product:Product!
}
