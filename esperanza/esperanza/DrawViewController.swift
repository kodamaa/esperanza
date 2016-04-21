//
//  DrawViewController.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/04/09.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    
    
    @IBOutlet var drawingView: ACEDrawingView!
    
    // 選択された日付の受取用パラメータ
    var dateParam = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
//        let canvas = UINib(nibName: "CanvasView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! ACEDrawingView
//        self.view.addSubview(canvas)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pen(sender: AnyObject) {
        self.drawingView.drawTool = ACEDrawingToolTypePen
    }
    
    @IBAction func line(sender: AnyObject) {
        self.drawingView.drawTool = ACEDrawingToolTypeLine
    }
    
    @IBAction func eraser(sender: AnyObject) {
        self.drawingView.drawTool = ACEDrawingToolTypeEraser
    }
    @IBAction func color(sender: AnyObject) {
        self.drawingView.lineColor = UIColor.orangeColor()
    }
}