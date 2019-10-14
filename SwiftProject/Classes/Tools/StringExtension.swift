//
//  StringExtension.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import CommonCrypto

extension String{
    
    func validatePhone() -> Bool{
        if self.count == 0 {
            return false
        }
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let isMatch = regexMobile.evaluate(with: self)
        return isMatch
    }
    
    func validatePsw() -> Bool{
        if self.count == 0 {
            return false
        }
        let pattern = "^\\w{6,16}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: self)
        return isMatch
    }
    
    
    //"2019-06-11T15:28:45.06"
    mutating func dateTtransformSSS() -> String{
        let formt = DateFormatter()
        formt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let date = formt.date(from: self) else{
            return "2019-01-01"
        }
        formt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formt.string(from: date)
    }
    
    mutating func dateTtransform() -> String{
        let formt = DateFormatter()
        formt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = formt.date(from: self) else{
            return "2019-01-01"
        }
        formt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formt.string(from: date)
    }
    
}


extension String {
    // MD5 加密字符串
    var MD5: String {
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString()
        for i in 0..<16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}

extension String{
    func sha1() -> String{
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {output.appendFormat("%02x", byte)}
        return output as String
    }
}
