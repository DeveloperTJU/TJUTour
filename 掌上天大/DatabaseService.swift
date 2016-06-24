//
//  databaseService.swift
//  Memo
//
//  Created by hui on 16/5/26.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class DatabaseService: NSObject {
    
    var database:FMDatabase!
    var dbQueue:FMDatabaseQueue!
    class var sharedInstance:DatabaseService {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:DatabaseService? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = DatabaseService()
        })
        return Static.instance!
    }
    
    override init(){
        super.init()
        self.database = self.getDatabase()
        self.dbQueue = self.getDatabaseQueue()
    }
    
    func getDatabase() -> FMDatabase{
        let fileManager = NSFileManager.defaultManager()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !fileManager.fileExistsAtPath(appDelegate.databasePath){
            let db = FMDatabase(path: appDelegate.databasePath)
            if db == nil{
                print("Error:\(db.lastErrorMessage())")
            }
            if db.open(){
                let sqlStr = "CREATE TABLE IF NOT EXISTS FAVORITES(NAME TEXT, NUM TEXT, PRIMARY KEY(NUM))"
                if !db.executeUpdate(sqlStr, withArgumentsInArray: []) {
                    print("Error:\(db.lastErrorMessage())")
                }
                db.close()
            }
            else{
                print("Error:\(db.lastErrorMessage())")
            }
        }
        return FMDatabase(path: appDelegate.databasePath)
    }
    
    func getDatabaseQueue() -> FMDatabaseQueue {
        return FMDatabaseQueue(path: (UIApplication.sharedApplication().delegate as! AppDelegate).databasePath)
    }
    
}
