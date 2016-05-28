//
//  realmModel.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/05/28.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import Foundation
import RealmSwift

class realmModel {
    let realm = try! Realm()
    
    func loadImageDataFromDB(dateString:String) -> NSData {
        let predicate = NSPredicate(format: "day = %@ ", dateString)
        // Result object はコレクション形式
        let query = realm.objects(CanvasData).filter(predicate)
        if ((query.first?.imageData) != nil) {
            return (query.first?.imageData)!
        }
        else {
            return NSData()
        }
    }
    
    func  saveImageToDB(image:UIImage, date:String) {
        let data = UIImagePNGRepresentation(image)!
        // create
        let canvasData = CanvasData()
        canvasData.imageData = data
        canvasData.day = date
        
        try! realm.write {
            // データが無ければ追加、あれば更新
            realm.add(canvasData, update: true)
        }
    }
    
    // 指定した日付にデータが存在するか
    // 存在する -> true, 存在しない -> false
    func isExistData(dateString:String) -> Bool {
        let predicate = NSPredicate(format: "day = %@ ", dateString)
        // Result object はコレクション形式
        let query = realm.objects(CanvasData).filter(predicate)
        if ((query.first?.imageData) != nil) {
            return true
        }
        else {
            return false
        }
    }
}