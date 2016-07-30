//
//  DrawViewController.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/04/09.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, paletteViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate {
    
    @IBOutlet var drawingView: ACEDrawingView!
    @IBOutlet weak var toolBar: UIToolbar!
    var palette: paletteView!
    var dragImage = UIImageView()
    var beforePoint = CGPointMake(0.0, 0.0)
    var currentScale:CGFloat = 1.0
    
    // 選択された日付の受取用パラメータ
    var dateParam = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DrawViewController.viewTapped(_:))))
        self.drawingView.lineWidth = 3.0
        
        let imageData = loadImageDataFromRealm()
        // imageで渡すとサイズがおかしくなるためdata形式で渡している
        drawingView.loadImageData(imageData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToCalender(sender: AnyObject) {
        saveImageToRealm(drawingView.image)
        // move page
        let calenderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("calenderView") as! ViewController
        self.presentViewController(calenderViewController, animated: true, completion: nil)
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
        self.drawingView.lineWidth = 15.0
    }
    
    @IBAction func undo(sender: AnyObject) {
        self.drawingView.undoLatestStep()
    }
    
    @IBAction func redo(sender: AnyObject) {
        self.drawingView.redoLatestStep()
    }
    
    @IBAction func Clear(sender: AnyObject) {
        drawingView.loadImageData(NSData())
    }
    func viewTapped(sender: UITapGestureRecognizer) {
        // FIXME: panGestureのみをremoveできなかったため、全部消して必要なものだけ再度addしている
        // fix image position
        self.drawingView.gestureRecognizers?.removeAll()
        self.drawingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DrawViewController.viewTapped(_:))))
        
        // set image and reset
        if self.dragImage.image != nil {
            // make capture
            let img = self.toImage(self.drawingView)
            self.drawingView.loadImage(img)
            self.dragImage.image = nil
            self.currentScale = 1.0
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
    @IBAction func selectCameraOrLibrary(sender: AnyObject) {
        let alert = UIAlertController(title:nil,
            message:nil,
            preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "キャンセル",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
        })
        let takePicture = UIAlertAction(title: "写真を撮る",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                self.pickImageFromCamera()
        })
        let selectPicture = UIAlertAction(title: "カメラロールから選択する",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                self.pickImageFromLibrary()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(takePicture)
        alert.addAction(selectPicture)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // take picture
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // choose picture from library
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // After image was chosen
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
            
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(DrawViewController.pinchAction(_:)))
            self.drawingView.addGestureRecognizer(pinch)
            
            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(DrawViewController.dragAction(_:)))
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
    
    func pinchAction(sender:UIPinchGestureRecognizer) {
        var scale = sender.scale
        if self.currentScale > 1.0{
            scale = self.currentScale + (scale - 1.0)
        }
        switch sender.state{
        case .Changed:
            let scaleTransform = CGAffineTransformMakeScale(scale, scale)
            let transitionTransform = CGAffineTransformMakeTranslation(self.beforePoint.x, self.beforePoint.y)
            self.dragImage.transform = CGAffineTransformConcat(scaleTransform, transitionTransform)
        case .Ended , .Cancelled:
            if scale <= 1.0{
                self.currentScale = 1.0
                self.dragImage.transform = CGAffineTransformIdentity
            }else{
                self.currentScale = scale
            }
        default:
            break
        }
    }
    
    // MARK: color change
    // TODO: Fixed change height with animation
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
    
    // MARK: Realm
    func saveImageToRealm(image:UIImage) {
        let instance = realmModel()
        instance.saveImageToDB(image, date: self.dateParam)
    }
    
    func loadImageDataFromRealm() -> NSData {
        let instance = realmModel()
        let image = instance.loadImageDataFromDB(self.dateParam)
        return image
    }
}