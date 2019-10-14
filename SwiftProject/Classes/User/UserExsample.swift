//
//  UserExsample.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import MJExtension

class UserExsample: NSObject {

    @objc var name : String?
    @objc var age : Int = 0
    
    @objc var book : [String : AnyObject]? {
        didSet {
            bookModel = Book.mj_object(withKeyValues: book)
        }
    }
    var bookModel : Book?
}

class Book : NSObject {
    @objc var name : String?
    @objc var page : Int = 0
}
