//
//  SetupViewController.swift
//  掌上天大
//
//  Created by zyf on 16/6/29.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController,UIAlertViewDelegate {
    
    var navigationBlurView:UIVisualEffectView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let mainSize = self.view.bounds.size
        self.view.backgroundColor = .whiteColor()
        let img = UIImage(named:"background")
        let vImg = UIImageView(image: img)
        vImg.frame = CGRect(x:0,y:0,width:mainSize.width ,height:mainSize.height)
        self.view.sendSubviewToBack(vImg)
        self.view.addSubview(vImg)
        let vLogin = UIView(frame:CGRectMake(10, 180, mainSize.width - 20, 88))
        self.view.addSubview(vLogin)
        vLogin.addSubview(MyRect(frame: CGRectMake(0, 41, mainSize.width - 20, 3)))
        vLogin.layer.cornerRadius = 3
        vLogin.backgroundColor = .whiteColor()
        let button1:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button1.frame = CGRectMake(0, 0, vLogin.frame.size.width , 44)
        button1.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        button1.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        button1.layer.cornerRadius = 4
        //设置按钮文字
        button1.setTitle("清除缓存", forState:UIControlState.Normal)
        button1.addTarget(self,action:Selector("tapped1:"),forControlEvents: .TouchUpInside)
        vLogin.addSubview(button1)
        
        let button2:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button2.frame = CGRectMake(0, 48, vLogin.frame.size.width , 44)
        button2.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        button2.tintColor = UIColor(red: 232/255, green: 208/255, blue: 120/255, alpha: 1)
        button2.layer.cornerRadius = 4
        //设置按钮文字
        button2.setTitle("关于我们", forState:UIControlState.Normal)
        button2.addTarget(self,action:Selector("tapped2:"),forControlEvents: .TouchUpInside)
        vLogin.addSubview(button2)
        

    }
    
    func tapped1(button:UIButton){
        clearCache()
        
    }
    
    func tapped2(button:UIButton){
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
        
        
    }
    //统计缓存大小
    func fileSizeOfCache()-> Int {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        //缓存目录路径
        print(cachePath)
        if NSFileManager.defaultManager().fileExistsAtPath(cachePath!){
            // 取出文件夹下所有文件数组
            let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
            //快速枚举出所有文件名 计算文件大小
            var size = 0
            for file in fileArr! {
                // 把文件名拼接到路径中
                let path = cachePath?.stringByAppendingString("/\(file)")
                // 取出文件属性
                let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path!)
                // 用元组取出文件大小属性
                for (abc, bcd) in floder {
                    // 累加文件大小
                    if abc == NSFileSize {
                        size += bcd.integerValue
                    }
                }
            }
            let mm = size / 1024
            return mm
        }else{
            return 0
        }
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.UserDomainMask, true).first
            if NSFileManager.defaultManager().fileExistsAtPath(cachePath!){
                // 取出文件夹下所有文件数组
                let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
                // 遍历删除
                for file in fileArr! {
                    let path = cachePath?.stringByAppendingString("/\(file)")
                    if NSFileManager.defaultManager().fileExistsAtPath(path!) {
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(path!)
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
    //清理缓存
    func clearCache() {
        let frame = CGRectMake(self.view.bounds.size.width/2-5, self.view.bounds.size.height/2-50, 10, 10)
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: frame)
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.color = UIColor.grayColor()
        indicator.hidesWhenStopped = true
        // self.view.addSubview(indicator)
        indicator.startAnimating()
        let size = self.fileSizeOfCache()
        var message = "\(size)K缓存"
        if size > 1024{
            message = "\(size/1024)M缓存"
        }
        print(message)
        
        let alert = UIAlertView(title: "清理缓存", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
        
    }
    



}
