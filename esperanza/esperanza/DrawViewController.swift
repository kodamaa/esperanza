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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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