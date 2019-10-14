//
//  LessonModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/1.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON

struct VideoModel: HandyJSON{
    
    var ID: Int = 0
    var Title: String!
    var VideoUrl: String!
    var Dat: String!
    var ImgUrl: String!
    var Recommend: Int = 0
    var Price: Float = 0
    var Details: String!
    var PlayCount: Int = 0
    var TypeID: Int = 0
    var PPTUrl: String!
    var FileUrl: String!
    var FileName: String!
    var PPTName:String!
    
//    "ID": 5,
//    "Title": "一不小心进了视频圈",
//    "VideoUrl": "/Video/SYSOpenVideo/G_20190606152050538.mp4",
//    "Dat": "2019-03-22T10:03:00",
//    "ImgUrl": "/images/SYSOpenVideo/G_5.png?20190517150725?20190606152028",
//    "Recommend": 0,
//    "Price": 0,
//    "Details": "黎培璐 - 更新至08集",
//    "PlayCount": 1,
//    "TypeID": 1,
//    "PPTUrl": "",
//    "FileUrl": "",
//    "PPTName": "",
//    "FileName": "",
}

struct VideoDataItem:HandyJSON {
    var SYSOpenVideo:[VideoModel]!
    var TypeName:String!
}
