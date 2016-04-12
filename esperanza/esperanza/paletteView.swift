//
//  paletteView.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/04/11.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import UIKit

@objc protocol paletteViewDelegate {
    // デリゲートメソッド定義
    func changeDrawColor(tag:Int)
}

class paletteView: UIView {
    
    weak var delegate: paletteViewDelegate?
    
    @IBAction func colorTapped(sender: AnyObject) {
        self.colorChanged(sender.tag)
    }
    
    func colorChanged(tag:Int) {
        self.delegate?.changeDrawColor(tag)
    }
}


