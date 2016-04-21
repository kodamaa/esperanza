//
//  customCell.swift
//  esperanza
//
//  Created by ぽわるん on 2016/04/14.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

class CustomCell: UICollectionViewCell {
    var label: UILabel!
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        // UILabelを生成
        label = UILabel(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        label.font = UIFont(name: "HiraKakuProN-W3", size: 20)
        label.textAlignment = NSTextAlignment.Center
        
        // Cellに追加
        self.addSubview(label!)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
}