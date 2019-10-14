//
//  MoneyModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/11.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import HandyJSON

struct Remainder: HandyJSON {
    var ID: Int = 0
    var money: Float = 0
    var ImgUrl: String!
    var Remarks: String!
    var AddTime: String!
    var UserName: String!
    var state: String!
    var `Type`: String!
    var Balanceofpayments: String!
    var B_Name: String!
    var DatVerify: String!
    var CodeNumber: String!
}

struct UserMoney: HandyJSON {
    var ID: Int = 0
    var useNum: Int = 0
    var UserName: String!
    var Name: String!
    var Phone: String!
    var PassWord: String!
    var Card: String!
    var CardUrl: String!
    var C_UserTypeID: Int = 0
    var state: String!
    var Identifier: String!
    var Chief: Int = 0
    var Introducer: String!
    var DatCreate: String!
    var DatLogin: String!
    var DatPwdChange: String!
    var DatVerify: String!
    var PortraitUrl: String!
    var IsValid: Bool = false
    var wxNo: String!
    var Money: Float = 0
    var WxQRCode: String!
    var Province: String!
    var City: String!
    var Area: String!
    var Recharge: Float = 0
    var DueVerify: String!
    var WxOpenId: String!
    var TypeCode: String!
    var RebateMoney: Float = 0
    var Integral: Float = 0
}

struct RechargeItem : HandyJSON {
    var ID: Int = 0
    var ParametersKey: String!
    var ParametersVal: String!
    var Sort: Int = 0
    var Remark: String!
    var `Type`: String!
    var NickName: String!
    var IsValid: Bool = false
    var IsShow: Bool = false
    var valType: String!
    var TotalRowsInTable: Int = 0
    var Rate: Int = 0
}


struct C_UserRebateItem    : HandyJSON {
    var ID: Int = 0
    var Issuer: String!
    var `Type`: String!
    var State: String!
    var Money: Float = 0.0
    var DatCreat: String!
    var DatVerity: String!
    var R_People: String!
    var B_User: String!
    var Rate: String!
    var Cat: String!
    var OrderNo: String!
    var tjType: Int = 0
    var OrderMoney: Float = 0
    var UserRebateName: String!
    var TotalRowsInTable: Int = 0
    var ProductCnt: Int = 0
    var 年: Int = 0
    var 月: Int = 0
    var 返利合计: Float = 0
    var 订单总额: Float = 0
    var SumPrice: Float = 0
}

struct _data    : HandyJSON {
    var C_UserRebate: [C_UserRebateItem]!
    var TotalCommission: Float = 0.0
    var RebateMoney: Float = 0.0
}
