//
//  OrderModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/31.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON

struct  Order  : HandyJSON {
    var ID: Int = 0
    var OrderNo: String!
    var OrderName: String!
    var OrderImgSrc: String!
    var SumPrice: Float = 0
    var DatCreate: String!
    var OrderState: String!
    var PayState: String!
    var PayPrice: Float = 0
    var DatPay: String!
    var DatSend: String!
    var AuditState: String!
    var SendState: String!
    var DatAudit: String!
    var DatFinish: String!
    var PayType: String!
    var PayBank: String!
    var UserName: String!
    var ParentUser: String!
    var PayUserName: String!
    var MailID: Int = 0
    var Postage: Int = 0
    var OrderMan: String!
    var OrderMobile: String!
    var Address: String!
    var Remark: String!
    var ScaleCount: Int = 0
    var ProductCnt: Int = 0
    var E_UserName: String!
    var E_State: String!
    var E_OrderNo: String!
    var OrderType: String!
    var C_UserTypeID: Int = 0
    var AgentPrice: Float = 0
}


struct ProductSnapListItem : HandyJSON {
    var ID: Int = 0
    var ProductID: Int = 0
    var IsDel: Bool = false
    var DatEdit: String!
    var OrderNo: String!
    var ProductName: String!
    var Main_img: String!
    var Detail: String!
    var SalePrice: Float = 0
    var isPostFree: Bool = false
    var BuyPrice: Float = 0
    var GetCnt: Int = 0
    var DiscountRate: Int = 0
    var DatDiscountB: String!
    var DatDiscountE: String!
    var Freight: Float = 0
    var ProductDetiles: String!
}

struct MOrderVMItem:HandyJSON {
    var order:Order!
    var ProductSnapList:[ProductSnapListItem]!
}

struct PostInfo : HandyJSON {
    var ID: Int = 0
    var OrderNo: String!
    var CodeID: Int = 0
    var PostName: String!
    var PostNo: String!
    var Dat: String!
    var TotalRowsInTable: Int = 0
}
