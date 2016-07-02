//
//  AppDelegate.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

let mapVC = BaiduMapOfTJUViewController()
var Buildings = [BuildingData]()
var BuildingDict = Dictionary<String, NSInteger>()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {
    var _mapManager: BMKMapManager?
    var window: UIWindow?
    var databasePath:String!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //baidumap
        _mapManager = BMKMapManager()
        let ret = _mapManager?.start("7swNK08V4eriNyB5FlM1QrMde81CrV6Y", generalDelegate: self)
        
        if ret == false {
            NSLog("manager start failed!")
        }
        
        // Override point for customization after application launch.
        let dirParh = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirParh[0] as NSString
        self.databasePath = docsDir.stringByAppendingPathComponent("data.db")
        
        let screenFrame = UIScreen.mainScreen().bounds
        self.window = UIWindow(frame: screenFrame)
        self.window?.backgroundColor = .whiteColor()
        self.window?.makeKeyAndVisible()
        
        UITextField.appearance().font = UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        UITextField.appearance().tintColor = .blackColor()
        
        self.window?.rootViewController = HomeContainerViewController()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }

}

