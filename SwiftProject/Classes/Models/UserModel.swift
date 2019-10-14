//
//  UserModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/29.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON

struct UserModel  : HandyJSON {
    var ID: Int = 0
    var Money: Int = 0
    var DatVerify: String!
    var Province: String!
    var DatPwdChange: String!
    var TotalRowsInTable: Int = 0
    var Recharge: Float = 0
    var DatCreate: String!
    var Introducer: String!
    var AppOpenId: String!
    var userTypeLever: Int = 0
    var Phone: String!
    var RebateMoney: Float = 0
    var useNum: Int = 0
    var state: String!
    var PassWord: String!
    var PortraitUrl: String!
    var Name: String!
    var Identifier: String!
    var UserName: String!
    var Chief: Int = 0
    var DueVerify: String!
    var City: String!
    var TypeCode: String!
    var WxQRCode: String!
    var IsValid: Bool = false
    var DatLogin: String!
    var WxOpenId: String!
    var Card: String!
    var CardUrl: String!
    var Area: String!
    var wxNo: String!
    var Integral: Float = 0
    var C_UserTypeID: Int = 0
    var userTypeName: String!
    var XOpenId: String!
    var MyCommission:Float = 0
}


struct WeixinTokenModel    :  HandyJSON{
    var refresh_token: String!
    var unionid: String!
    var scope: String!
    var openid: String!
    var expires_in: Int = 0
    var access_token: String!
}
