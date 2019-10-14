//
//  AddressModel.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/3.
//  Copyright © 2019 icx. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON

struct Address:HandyJSON {
    
    var ID: Int = 0
    var UserName: String!
    var ContactName: String!
    var ContactMobile: String!
    var Province: String!
    var ProvinceID: Int = 0
    var City: String!
    var CityID: Int = 0
    var Area: String!
    var AreaID: Int = 0
    var Address: String!
    var IsDefault: Bool = false
    var IsNow: Bool = false
    var TotalRowsInTable: Int = 0

}


struct Town    : HandyJSON {
    var id: Int = 0
    var name: String!
}

struct City    : HandyJSON {
    var id: Int = 0
    var name: String!
    var child: [Town]?
}

struct Province    : HandyJSON {
    var id: Int = 0
    var name: String!
    var child: [City]!
}


class AddressModel{
    
    class func getCitys() -> [Province] {
        
        guard let file = Bundle.main.path(forResource: "Cities", ofType: "txt") else {
            return [Province]()
        }
      
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file), options: .dataReadingMapped) else{
            return [Province]()
        }
        
        guard let json = try? JSON(data: data) else{
            return [Province]()
        }
        
        var provinces = [Province]()
        
        for p in json.arrayValue {
            guard let item = Province.deserialize(from: p.rawString()) else{
                break
            }
            provinces.append(item)
        }
        
        return provinces
    
    }
    
    
    class func getCitiesName(pID:Int,cID:Int,tID:Int) -> (p:String,c:String,t:String) {
        
        let cities = self.getCitys()
        
        let p = cities.filter{
            return $0.id == pID
        }
        
        let city = p.first?.child.filter{
            return $0.id == cID
        }
        
        let town = city?.first?.child?.filter{
            return $0.id == tID
        }
        
        return (p.first?.name ?? "",city?.first?.name ?? "",town?.first?.name ?? "")
        
    }
    
}
