//
//  ViewController.swift
//  esperanza
//
//  Created by 影山 大輔 on 2016/04/09.
//  Copyright © 2016年 tokonatsutan. All rights reserved.
//

import UIKit

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let dayPerWeeks = 7
    let cellMargin: CGFloat = 2
    // 表示中の月のデータのコンテナ
    var	selectedDate = NSDate()
    var currentDate: NSDate!
    let week = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var textLabel: UILabel!
    
    @IBOutlet weak var CalenderDateCell: UICollectionView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDateFormatter()
        date.dateFormat = "yyyy/M"
        currentDate = NSDate()
        headerTitle.text = date.stringFromDate(currentDate)
        headerTitle.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        //calenderCollectionView.backgroundColor = UIColor.whiteColor()
    }

    // 先月押下時のアクション
    @IBAction func prevTap(sender: AnyObject) {
        let calendar = NSCalendar.currentCalendar()
        
        let dateComponents = NSDateComponents()
        // 1月マイナス
        dateComponents.month = -1
        self.currentDate = calendar.dateByAddingComponents(dateComponents, toDate: self.currentDate, options: NSCalendarOptions(rawValue: 0))!
        let formattar = NSDateFormatter()
        formattar.dateFormat = "yyyy/M"
        headerTitle.text = formattar.stringFromDate(currentDate)
        headerTitle.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        // view を更新する
        self.CalenderDateCell.reloadData()
    }
    
    // 次月押下時のアクション
    @IBAction func nextTap(sender: AnyObject) {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        // 1月プラス
        dateComponents.month = 1
        self.currentDate = calendar.dateByAddingComponents(dateComponents, toDate: self.currentDate, options: NSCalendarOptions(rawValue: 0))!
        let formattar = NSDateFormatter()
        formattar.dateFormat = "yyyy/M"
        headerTitle.text = formattar.stringFromDate(currentDate)
        headerTitle.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        // view を更新する
        self.CalenderDateCell.reloadData()
    }
    
    // その月の初日を返す
    func firstDateOfMonth() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let component =  calendar.components([.Year, .Month, .Day],fromDate:currentDate)
        component.day = 1
        let firstDateOfMonth = calendar.dateFromComponents(component)
        
        return firstDateOfMonth!
    }
    
    // index -> 日付へ変換する
    func dateForCellAtIndexPath(indexPass:NSIndexPath) -> NSDate {
        // 月の初日が何番目かを調べる
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let firstDay = calendar.ordinalityOfUnit(NSCalendarUnit.Day,
                                                 inUnit: NSCalendarUnit.WeekOfMonth,
                                                 forDate: firstDateOfMonth())
        
        // 「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
        let dateComponents = NSDateComponents()
        
        // +7 は曜日表示分ずらすため
        dateComponents.day = indexPass.item - (firstDay - 1 + 7)
        let date = calendar.dateByAddingComponents(dateComponents, toDate: firstDateOfMonth(), options: NSCalendarOptions(rawValue: 0))!
        
        return date
    }
    // Mark: UICollectionViewDataSource methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let calendar = NSCalendar.currentCalendar()
        
        // その月が何週あるか調べる
        let rangeOfWeeks = calendar.rangeOfUnit(NSCalendarUnit.WeekOfMonth,
                                                inUnit: NSCalendarUnit.Month,
                                                forDate: firstDateOfMonth())
        // 1ヶ月が何週あるか
        let numberOfWeeks = rangeOfWeeks.length
        // その月のカレンダーの総日数。
        // +1 しているのは曜日の列分追加するため
        let numberOfItems = (numberOfWeeks + 1) * dayPerWeeks
        
        return numberOfItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // UICollectionViewCell. カレンダーの日付ラベルを持ってるくらい。
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        // １列目（ < 7）は曜日をセットする
        if indexPath.row < 7 {
            cell.label!.text = week[indexPath.row]
        } else {
            // ２列目からはカレンダーに表示する日付
            let formatter = NSDateFormatter()
            formatter.dateFormat = "d"
            cell.label!.text = formatter.stringFromDate(self.dateForCellAtIndexPath(indexPath))
        }
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.label.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.label.textColor = UIColor.lightBlue()
        } else {
            cell.label.textColor = UIColor.grayColor()
        }
        return cell
    }
    
    // Mark: UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfMargin = CGFloat(8)
        let rateOfWidth = CGFloat(1.5)
        
        let width: CGFloat = floor((collectionView.frame.size.width - CGFloat(cellMargin) * numberOfMargin) / CGFloat(dayPerWeeks))
        
        // width と height は 1:1.5
        let height: CGFloat = width * rateOfWidth
        
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedDate = self.dateForCellAtIndexPath(indexPath)
    }
    
     // 画面遷移
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let drawViewController = segue.destinationViewController as! DrawViewController
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        // DBへは日付の文字列で保存する
        drawViewController.dateParam = dateFormatter.stringFromDate(self.selectedDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}