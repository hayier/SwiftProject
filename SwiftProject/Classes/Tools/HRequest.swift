//
//  HRequest.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/28.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

let BASEURL = "http://xxx.xxx.xxx/MobileApi/"

enum BuyType:String{
    case cart = "cart"
    case mail = "mail"
}

enum AddressEditType:String{
    case add = "add"
    case edit = "edit"
    case delete = "delete"
}

enum CheckType:Int{
    case unchecked = 0
    case checked = 1
}

enum API{
    case OtherLogin(account:String,pwd:String)
    case WxAppOpenidRegister(openid:String,token:String)
    case Register(Phone:String,pwd:String)
    case EditMypwd(key:String,oldpwd:String,newpwd:String)
    case GetMobileCode(mobile:String)
    case EditPwd(phone:String,pwd:String)
    case WxAppBindingMobile(phone:String,wxusername:String)
    
    
    case GetProducAll
    case ProducTypeName(typename:String)
    case ProducID(id:String)
    case GetGoodsDetail(id:Int)
    case GetGoodsType
    case GetCart(key:String)
    case AddToCart(key:String,ProductID:Int,GetCnt:Int,GroupID:Int)
    case EditFromCart(key:String,ProductID:Int,GetCnt:Int,GroupID:Int)
    case BatchRemove(key:String,id:String)
    case CheckByID(id:Int,type:CheckType,groupid:Int)
    case PlaceOrder(key:String,mpk:String,cartids:String,type:BuyType,addressId:Int,cnt:Int,groupid:Int)
    case OrderCreate(key:String,mpk:String,mailpk:String,cartpks:String,type:BuyType,mcnt:Int,groupids:String,Remark:String,mode:String)
    case CartBatchRemove(key:String,id:String)
    case CartCheck(id:Int,type:Int,groupid:Int)
    
    case GeUserMailAll(key:String)
    case UserMailAddorEdit(key:String,id:Int,ContactName:String,ContactMobile:String,ProvinceID:String,CityID:String,AreaID:String,Address:String,type:AddressEditType)
    
    case GetVideAll
    case GetVideDetails(id:String)
    
    case GeUserTeam(key:String)
    case GeLoanDetail(key:String)
    case GetUserRebateAll(key:String)
    
    case GeOrderAll(key:String,pageIndex:Int,OrderState:String)
    case GeOrderDetail(orderno:String)
    case OrderReceiving(orderno:String) //ApiUserOrder/OrderReceiving
    case ApplyRefund(orderno:String)   //ApiUserOrder/ApplyRefund
    case GeOrderAllRefund(key:String)    //ApiUserOrder/GeOrderAllRefund

    case GetRecharge
    case RechargeBalance(key:String,id:String) //充值
    case WxRecharge(key:String,id:String)  //微信充值回调
    case GiveCommission(key:String,username:String,money:String,remarks:String)  //赠送佣金
    case CommissionCash(key:String,money:String,payee_account:String,payee_real_name:String,Remarks:String)   //佣金提现
    
    //hyfpc.fangcuanhuoxitong.com/MobileApi/ApiUserOrder/WXCallback 参数：string orderno（订单号）
    case WXCallback(orderno:String,mode:String)
    //ApiUserOrder/WxAppPays
    case WxAppPays(orderno:String,openid:String)
    //ApiUserAlipay/AlipayOrder
    case AlipayOrder(orderno:String)
    
    
    case GetUser(key:String)
    case WxChangeHeadImg(key:String,imgurl:String)
    
    case IntegralExchange(key:String,Integral:String)
    
    case RechargeParty(key:String,id:String)  //ApiUserOrder/ RechargeParty
    
    case RechargePartyCopy(key:String,money:String)//ApiUserOrder/RechargePartyCopy

    case GetTXRecord(key:String)    //ApiUserRebate/GetTXRecord 佣金提现记录
    
    case AppInvitelinks(key:String)
}

extension API{
    var url:String{
        switch self {
        case .OtherLogin(_,_):
            return BASEURL + "User/OtherLogin"
        case .Register:
                return BASEURL + "User/Register"
        case .WxAppOpenidRegister:
            return BASEURL + "ApiUserWxInfo/WxAppOpenid"
        case .EditMypwd:
            return BASEURL + "User/EditMypwd"
        case .GetMobileCode:
            return BASEURL + "ApiUserRebate/GetMobileCode"
        case .EditPwd:
            return BASEURL + "User/EditPwd"
        case .WxAppBindingMobile:
            return BASEURL + "ApiUserWxInfo/WxAppBindingMobile"
            
        case .GetProducAll:
            return BASEURL + "ApiProduct/GetProducAll"
        case .ProducTypeName(_):
            return BASEURL + "ApiProduct/GetProducTypeName"
        case .ProducID(_):
            return BASEURL + "ApiProduct/GetProducID"
        case .GetGoodsDetail(_):
            return BASEURL + "ApiProduct/GetGoodsDetail"
        case .GetGoodsType:
            return BASEURL + "ApiProduct/GetGoodsType"
        case .GetCart(_):
            return BASEURL + "ApiUserCart/GetCart"
        case .AddToCart(_,_,_,_):
            return BASEURL + "ApiUserCart/AddToCart"
        case .EditFromCart(_,_,_,_):
            return BASEURL + "ApiUserCart/EditFromCart"
        case .BatchRemove(_,_):
            return BASEURL + "ApiUserCart/BatchRemove"
        case .CheckByID(_,_,_):
            return BASEURL + "ApiUserCart/CheckByID"
        case .PlaceOrder(_,_, _, _, _, _, _):
            return BASEURL + "ApiUserOrder/PlaceOrder"
        case .OrderCreate(_,_,_,_,_,_,_,_,_):
            return BASEURL + "ApiUserOrder/OrderCreate"
        case .CartBatchRemove(_,_):
            return BASEURL + "ApiUserCart/BatchRemove"
        case .CartCheck(_,_,_):
            return BASEURL + "ApiUserCart/CheckByID"
        case .GeUserMailAll(_):
            return BASEURL + "ApiUserMail/GeUserMailAll"
        case .UserMailAddorEdit(_,_,_,_,_,_,_,_,_):
            return BASEURL + "ApiUserMail/UserMailAddorEdit"
        case .GetVideAll:
            return BASEURL + "ApiOpenSource/GetVideAll"
        case .GetVideDetails(_):
            return BASEURL + "ApiOpenSource/GetVideDetails"
        case .GeUserTeam(_):
            return BASEURL + "ApiUserTeam/GeUserTeam"
        case .GeLoanDetail(_):
            return BASEURL + "ApiUserRecharge/GeLoanDetail"
        case .GetUserRebateAll(_):
            return BASEURL + "ApiRecharge/GetUserRebateAll"
        case .GeOrderAll(_):
            return BASEURL + "ApiUserOrder/GeOrderAll"
        case .GeOrderDetail:
            return BASEURL + "ApiUserOrder/GeOrderDetail"
        case .OrderReceiving: //ApiUserOrder/OrderReceiving
            return BASEURL + "ApiUserOrder/OrderReceiving"
        case .ApplyRefund:
            return BASEURL + "ApiUserOrder/ApplyRefund"
        case .GeOrderAllRefund:
            return BASEURL + "ApiUserOrder/GeOrderAllRefund"
        case .GetRecharge:
            return BASEURL + "ApiUserOrder/GetRecharge"
        case .RechargeBalance(_,_):
            return BASEURL + "ApiUserOrder/RechargeBalance"
        case .WxRecharge:
            return BASEURL + "ApiUserOrder/WxRecharge"
        case .GiveCommission:
            return BASEURL + "ApiUserRebate/GiveCommission"
        case .CommissionCash:
            return BASEURL + "ApiUserRebate/Cash"
        case .WXCallback:
            return BASEURL + "ApiUserOrder/WXCallback"
        case .WxAppPays:
            return BASEURL + "ApiUserOrder/WxAppPaysCopy"
        case .AlipayOrder:
            return BASEURL + "ApiUserAlipay/AlipayOrder"
            
            
        case .GetUser:
            return BASEURL + "ApiUserWxInfo/GetUser"
        case .WxChangeHeadImg:
            return BASEURL + "User/WxChangeHeadImg"
        
        case .IntegralExchange:
            return BASEURL + "ApiUserRebate/IntegralExchange"
           
        case .RechargeParty:
            return BASEURL + "ApiUserOrder/RechargeParty"
        case .GetTXRecord:
            return BASEURL + "ApiUserRebate/GetTXRecord"
        case .AppInvitelinks:
            return BASEURL + "ApiOpenSource/AppInvitelinks"
        case .RechargePartyCopy:
            return BASEURL + "ApiUserOrder/RechargePartyCopy"
        }
    }
}

extension API {
    var params:[String:Any]{
        switch self {
        case .OtherLogin(let account, let pwd):
            return ["account":account,"pwd":pwd]
        case .Register(let Phone, let pwd):
            return ["Phone":Phone,"pwd":pwd]
        case .WxAppOpenidRegister(let openid,let token):
            return ["openid":openid,"token":token]
        case .EditMypwd(let key,let oldpwd, let newpwd):
            return ["key":key,"oldpwd":oldpwd,"newpwd":newpwd]
        case .GetMobileCode(let mobile):
            return ["mobile":mobile]
        case .EditPwd(let phone, let pwd):
            return ["phone":phone,"pwd":pwd]
        case .WxAppBindingMobile(let phone, let wxusername):
            return ["phone":phone,"wxusername":wxusername]
            
        case .GetProducAll:
            return ["":""]
        case .ProducTypeName(let typename):
            return ["typename":typename]
        case .ProducID(let id):
            return ["id":id]
        case .GetGoodsDetail(let id):
            return ["id":id]
        case .GetCart(let key):
            return ["key":key]
        case .AddToCart(let key, let ProductID, let GetCnt, let GroupID):
            return ["key":key,"ProductID":ProductID,"GetCnt":GetCnt,"GroupID":GroupID]
        case .EditFromCart(let key, let ProductID, let GetCnt, let GroupID):
             return ["key":key,"ProductID":ProductID,"GetCnt":GetCnt,"GroupID":GroupID]
        case .BatchRemove(let key, let id):
            return ["key":key,"id":id]
        case .CheckByID(let id, let type, let groupid):
            return ["id":id,"type":type,"groupid":groupid]
        case .GetGoodsType:
            return [:]
        case .PlaceOrder(let key,let mpk, let cartids, let type, let addressId, let cnt, let groupid):
            return ["key":key,"mpk":mpk,"cartids":cartids,"type":type.rawValue,"addressId":addressId,"cnt":cnt,"groupid":groupid]
        case .OrderCreate(let key, let mpk, let mailpk, let cartpks, let type, let mcnt, let groupids, let Remark , let mode):
            return ["key":key,"mpk":mpk,"mailpk":mailpk,"cartpks":cartpks,"type":type.rawValue,"mcnt":mcnt,"groupids":groupids,"Remark":Remark,"mode":mode]
        case .CartBatchRemove(let key, let id):
            return ["key":key,"id":id]
        case .CartCheck(let id, let type, let groupid):
            return ["id":id,"type":type,"groupid":groupid]
        case .GeUserMailAll(let key):
            return ["key":key]
        case .UserMailAddorEdit(let key, let id, let ContactName, let ContactMobile,let ProvinceID,let CityID,let AreaID, let Address, let type):
            return ["key":key,"id":id,"ContactName":ContactName,"ContactMobile":ContactMobile,"ProvinceID":ProvinceID,"CityID":CityID,"AreaID":AreaID,"Address":Address,"type":type.rawValue]
        case .GetVideAll:
            return [:]
        case .GetVideDetails(let id):
            return ["id":id]
        case .GeUserTeam(let key):
            return ["key":key]
        case .GeLoanDetail(let key):
            return ["key":key]
        case .GetUserRebateAll(let key):
            return ["key":key]
        case .GeOrderAll(let key,let pageIndex,let OrderState):
            return ["key":key,"pageIndex":pageIndex,"OrderState":OrderState]
        case .GeOrderDetail(let orderno):
            return ["orderno":orderno]
        case .GetRecharge:
            return [:]
        case .RechargeBalance(let key, let id):
            return ["key":key,"id":id]
        case .WxRecharge(let key, let id):
            return ["key":key,"id":id]
        case .GiveCommission(let key, let username, let money, let remarks):
            return ["key":key,"username":username,"money":money,"remarks":remarks]
        case .CommissionCash(let key, let money, let payee_account, let payee_real_name, let Remarks):
            return ["key":key,"money":money,"payee_account":payee_account,"payee_real_name":payee_real_name,"Remarks":Remarks]
        case .WXCallback(let orderno,let mode):
            return ["orderno":orderno,"mode":mode]
        case .WxAppPays(let orderno, let openid):
            return ["orderno":orderno,"openid":openid]
        case .AlipayOrder(let orderno):
            return ["orderno":orderno]
        case .GetUser(let key):
            return ["key":key]
        case .OrderReceiving(let orderno):
            return ["orderno":orderno]
        case .ApplyRefund(let orderno):
            return ["orderno":orderno]
        case .GeOrderAllRefund(let key):
            return ["key":key]
        case .WxChangeHeadImg(let key, let imgurl):
            return ["key":key,"imgurl":imgurl]
        case .IntegralExchange(let key, let Integral):
            return ["key":key,"Integral":Integral]
    
        case .RechargeParty(let key, let id):
            return ["key":key,"id":id]
        case .GetTXRecord(let key):
            return ["key":key]
        case .AppInvitelinks(let key):
            return ["key":key]
        case .RechargePartyCopy(let key, let money):
            return ["key":key,"money":money]
        }
    }
}

struct AuthRequest{
    
    func auth(){
        //URLConvertible
        Alamofire.request("www.baidu.com").authenticate(user: "user", password: "password").responseJSON{(res) in
            
        }
        
    }
    
}

class HRequest {
    
    static func getData(api:API, success:@escaping ((_ data:JSON)->Void)){
        
        Alamofire.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let commomModel = CommonModel.deserialize(from: json.rawString())
                if commomModel?._success ?? false{
                    let data = json["_data"]
                    success(data)
                }else{
                    guard let message = commomModel?._message else{
                        return
                    }
                    UIApplication.shared.keyWindow?.toast(message: message)
                }
            case .failure(let e):
                print(e)
                UIView.dismiss(delay: 0){}
            }
        }
        
    }
    
    static func getData(api:API, success:@escaping ((_ data:JSON)->Void) ,faild:((_ data:JSON)->Void)?){
        
        Alamofire.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let commomModel = CommonModel.deserialize(from: json.rawString())
                if commomModel?._success ?? false{
                    let data = json["_data"]
                    success(data)
                }else{
                    if let f = faild {
                        let data = json["_data"]
                        f(data)
                    }
                    guard let message = commomModel?._message else{
                        return
                    }
                    UIApplication.shared.keyWindow?.makeToast(message)
                }
            case .failure(let e):
                print(e)
                UIView.dismiss(delay: 0){}
            }
        }
        
    }
    
    let CacheManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let reachability = NetworkReachabilityManager()
      
        if (reachability?.isReachable)! {
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        }else
        {
            configuration.requestCachePolicy = .returnCacheDataElseLoad
        }
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    static let R:HRequest = {
        let r = HRequest()
        return r
    }()
    
    class func getCacheData(api:API, success:@escaping ((_ data:JSON)->Void)){
        
        R.CacheManager.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let commomModel = CommonModel.deserialize(from: json.rawString())
                if commomModel?._success ?? false{
                    let data = json["_data"]
                    success(data)
                }else{
                    guard let message = commomModel?._message else{
                        return
                    }
                    UIApplication.shared.keyWindow?.makeToast(message)
                }
            case .failure(let e):
                print(e)
                UIView.dismiss(delay: 0){}
            }
        }
        
    }
   
}

    
extension String {
    
    var imgRequestUrl:URL?{
        return URL(string: "http://xxx.xxx.xxx" + self)
    }
    
    var imgRequestString:String?{
        return "http://xxx.xxx.xxx" + self
    }
    
    func getRegexJPG() -> [String]?{
        
        do {
            let sArr = self.components(separatedBy: "jpg")
            var arrStr = [String]()
            for s in sArr[0..<sArr.count-1] {
                let regex = try NSRegularExpression(pattern: "/images[^\\s]+", options: [])
                let range = NSRange(location: 0, length: s.count)
                let match = regex.firstMatch(in: s, options: [], range: range)
                
                let nsStr = s as NSString
                guard let m = match else{break}
                let reStr = nsStr.substring(with: m.range) as String
                let img = reStr + "jpg"
                arrStr.append(img)
            }
            
           return arrStr
        } catch {
            print("bad regex")
        }
        return nil
    }
    
}
