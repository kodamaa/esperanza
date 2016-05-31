//
//  CanvasData.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/05/22.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import RealmSwift

class CanvasData: Object {
    dynamic var imageData = NSData()
    dynamic var day = String()
    
    override class func primaryKey() -> String {
        return "day"
    }
}