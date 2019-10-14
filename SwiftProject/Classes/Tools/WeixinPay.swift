//
//  WeixinPay.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/13.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import MonkeyKing
import HandyJSON

class WeixinPay {
    
    struct Params:HandyJSON {
        var appId: String!
        var nonceStr: String!
        var package: String!
        var paySign: String!
        var signType: String!
        var timeStamp: String!
        var sign: String!
        var key = "xxxxxxxxxxx"
        
    }
    
    public typealias completionHandler = (_ info: [String: Any]?, _ response: URLResponse?, _ error: Error?) -> Void
    public typealias payCompletionHandler = (_ result: Bool) -> Void
    
    static let appId = "xxxxxxx"
    static let appKey = "xxxxxxxxxxxxxxxx"
    
    class func isWeiXinInstall() -> Bool{
        
        return MonkeyKing.SupportedPlatform.weChat.isAppInstalled
        
    }
    
    class func register(){
    
        MonkeyKing.registerAccount(.weChat(appID: appId, appKey: appKey, miniAppID: nil))
        
        //WXApi.registerApp(appId)
    }
    
    // MARK:-OAuth
    class func OAuth(completionHandler: @escaping completionHandler) {
        MonkeyKing.oauth(for: .weChat) { (info, response, error) in
            completionHandler(info, response, error)
        }
    }
    
    //let urlString = "weixin://app/\(WXPayModel.appid!)/pay/?nonceStr=\(WXPayModel.noncestr!)&package=Sign%3DWXPay&partnerId=\(WXPayModel.partnerid!)&prepayId=\(WXPayModel.prepayid!)&timeStamp=\(UInt32(WXPayModel.timestamp!))&sign=\(WXPayModel.sign!)&signType=SHA1"
 
    
    class func createURL(params:Params) -> String?{
        
        let range = params.package.range(of: "prepay_id=")
        var prepayid = params.package
        prepayid?.removeSubrange(range!)
        
        let strA = "appid=\(params.appId!)&noncestr=\(params.nonceStr!)&package=Sign=WXPay&partnerid=xxxxxxxxxxx&prepayid=\(prepayid!)&timestamp=\(params.timeStamp!)"
        
        let sign = ("\(strA)&key=\(params.key)").MD5.uppercased()
        
        //req.sign = ("\(strA)&key=\(key)").MD5.uppercased()
        
        //let url = "weixin://app/\(params.appId!)/pay/?nonceStr=\(params.nonceStr!)&package=Sign%3DWXPay&partnerId=xxxxxxxxxx&prepayId=\(prepayid!)&timeStamp=\(params.timeStamp!)&sign=\(sign)&signType=SHA1"
        
        //微信支付开发 对比出错
        //1、认为后台应该已经配好二次签名参数直接可以使用
        //2、字符串的拼接nonceStr字段 等url不区分大小写的字段在此处应是当做key-value值传参使用，所以不能忽略大小值
        //3、signType判定，此字段并没有任何影响
        
        let urlString = "weixin://app/\(params.appId!)/pay/?nonceStr=\(params.nonceStr!)&package=Sign%3DWXPay&partnerId=xxxxxxxxx&prepayId=\(prepayid!)&timeStamp=\(params.timeStamp!)&sign=\(sign)&signType=SHA1"
    
        return urlString
    }
    
    // MARK:-Pay
    class func pay(urlString: String, completionHandler: @escaping payCompletionHandler) {
        let order = MonkeyKing.Order.weChat(urlString: urlString)
        MonkeyKing.deliver(order) { result in
            completionHandler(result)
        }
    }
    
    
}

class AliPay{
    
    //ApiUserAlipay/AlipayOrder
    class func isAliInstall() -> Bool{
        
        return MonkeyKing.SupportedPlatform.alipay.isAppInstalled
        
    }
    
}
