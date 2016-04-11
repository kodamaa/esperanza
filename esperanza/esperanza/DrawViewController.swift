//
//  DrawViewController.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/04/09.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, paletteViewDelegate {
    
    let toolbarHeight:CGFloat = 60
    
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
    
    // TODO: Fixed Animation height
    @IBAction func color(sender: AnyObject) {
        let palette = UINib(nibName: "Palette", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! paletteView
        //枠線
        palette.layer.borderWidth = 2.0
        //枠線の色
        palette.layer.borderColor = UIColor.blackColor().CGColor
        //角丸
        palette.layer.cornerRadius = 10.0
        palette.frame = CGRectMake(0, self.drawingView.frame.height, self.drawingView.frame.width, toolbarHeight)
        palette.backgroundColor = UIColor.lightGrayColor()
        palette.delegate = self
        self.view.addSubview(palette)
        
        UIView.animateWithDuration(0.5, // アニメーションの時間
            animations: {() -> Void  in
                // アニメーションする処理
                palette.frame.origin.y = self.drawingView.frame.height - self.toolbarHeight
        })
    }
    
    func changeDrawColor(tag:Int) {
        switch (tag) {
        case 1:
            self.drawingView.lineColor = UIColor.blackColor()
            break;
        case 2:
            self.drawingView.lineColor = UIColor.redColor()
            break;
        case 3:
            // orange
            self.drawingView.lineColor = UIColor(red: 241/255, green: 164/255, blue: 33/255, alpha: 1)
            break;
        case 4:
            // yellow
            self.drawingView.lineColor = UIColor(red: 242/255, green: 224/255, blue: 43/255, alpha: 1)
            break;
        case 5:
            // purple
            self.drawingView.lineColor = UIColor(red: 139/255, green: 18/255, blue: 248/255, alpha: 1)
            break;
        case 6:
            // blue
            self.drawingView.lineColor = UIColor(red: 48/255, green: 6/255, blue: 248/255, alpha: 1)
            break;
        case 7:
            // lightblue
            self.drawingView.lineColor = UIColor(red: 50/255, green: 191/255, blue: 249/255, alpha: 1)
            break;
        case 8:
            // green
            self.drawingView.lineColor = UIColor(red: 16/255, green: 181/255, blue: 28/255, alpha: 1)
            break;
        default:
            self.drawingView.lineColor = UIColor.blackColor()
            break;
        }
    }
}