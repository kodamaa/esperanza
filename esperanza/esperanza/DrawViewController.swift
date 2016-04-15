//
//  DrawViewController.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/04/09.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, paletteViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let toolbarHeight:CGFloat = 60
    
    @IBOutlet var drawingView: ACEDrawingView!
    @IBOutlet weak var toolBar: UIToolbar!
    var palette: paletteView!
    var dragImage = UIImageView()
    var pan = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped:"))
        self.drawingView.lineWidth = 3.0
        
        // FIXME: アニメーションにしたい
        self.toolBar.hidden = true
        //        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pen(sender: AnyObject) {
        self.drawingView.drawTool = ACEDrawingToolTypePen
        self.drawingView.lineWidth = 3.0
        self.drawingView.lineAlpha = 1.0
    }
    
    @IBAction func line(sender: AnyObject) {
        self.drawingView.drawTool = ACEDrawingToolTypePen
        self.drawingView.lineWidth = 12.0
        self.drawingView.lineAlpha = 0.8
    }
    
    @IBAction func eraser(sender: AnyObject) {
        self.drawingView.drawTool = ACEDrawingToolTypeEraser
    }
    
    @IBAction func showToolBar(sender: AnyObject) {
        self.toolBar.hidden = false
    }
    
    func viewTapped(sender: UITapGestureRecognizer) {
        self.toolBar.hidden = true
        
        // FIXME: panGestureのみをremoveできなかったため、全部消して必要なものだけ再度addしている
        // fix image position
        self.drawingView.gestureRecognizers?.removeAll()
        self.drawingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped:"))
        if self.dragImage.image != nil {
            // make capture
            let img = self.toImage(self.drawingView)
            self.drawingView.loadImage(img)
            self.dragImage.image = nil
        }
        if palette != nil {
            UIView.animateWithDuration(0.5, // アニメーションの時間
                animations: {() -> Void  in
                    // アニメーションする処理
                    self.palette.frame.origin.y = self.view.frame.height + self.toolBar.frame.height + self.palette.frame.height
            })
            palette = nil
        }
    }
    
    // MARK: set image
    @IBAction func setImage(sender: AnyObject) {
        // TODO: 実装する
//        self.pickImageFromCamera()
        
        self.pickImageFromLibrary()
    }
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let size = CGSize(width: 150, height: 150)
            UIGraphicsBeginImageContext(size)
            image.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.dragImage = UIImageView(image: resizeImage)
            self.dragImage.userInteractionEnabled = true

            self.drawingView.addSubview(self.dragImage)
            
            pan = UIPanGestureRecognizer.init(target: self, action: "dragAction:")
            self.drawingView.addGestureRecognizer(pan)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // @see: http://llcc.hatenablog.com/entry/2015/05/09/143511
    func toImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0.0, 0.0)
        view.layer.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // imageをドラッグで移動させるときに呼ばれる
    func dragAction(sender:UIPanGestureRecognizer) {
        let p = sender.translationInView(self.drawingView)
        let movePoint = CGPointMake(self.dragImage.center.x + p.x, self.dragImage.center.y + p.y)
        self.dragImage.center = movePoint
        sender.setTranslation(CGPoint.zero, inView: self.drawingView)
    }
    
    // MARK: color change
    // TODO: Fixed Animation height
    @IBAction func color(sender: AnyObject) {
        if self.palette == nil {
            self.palette = UINib(nibName: "Palette", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! paletteView
            self.palette.layer.borderWidth = 2.0
            self.palette.layer.borderColor = UIColor.blackColor().CGColor
            self.palette.layer.cornerRadius = 10.0
            self.palette.frame = CGRectMake(0, self.drawingView.frame.height, self.view.frame.width, self.toolBar.frame.height)
            self.palette.backgroundColor = UIColor.lightGrayColor()
            self.palette.delegate = self
            self.view.addSubview(self.palette)
            
            UIView.animateWithDuration(0.5,
                animations: {() -> Void  in
                    self.palette.frame.origin.y = self.view.frame.height - self.toolBar.frame.height - self.palette.frame.height
            })
        }
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