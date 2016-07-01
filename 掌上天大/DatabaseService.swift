//
//  databaseService.swift

//  Created by nmpp_il on 16/5/26.
//  Copyright © 2016年 nmpp_il. All rights reserved.
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
                var sqlStr = "CREATE TABLE IF NOT EXISTS BUILDING(ID TEXT, NAME TEXT, DETAIL TEXT,FAVOURITE INT, PRIMARY KEY(ID))"
                if !db.executeUpdate(sqlStr, withArgumentsInArray: []) {
                    print("Error:\(db.lastErrorMessage())")
                }
               
                sqlStr = "CREATE TABLE IF NOT EXISTS HISTORY(STR TEXT, PRIMARY KEY(STR))"
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
    
    func insert(buildingData : BuildingData) -> Bool{
        self.database.open()
        let sqlStr = "INSERT INTO BUILDING VALUES (?, ? ,? ,?)"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [buildingData.id, buildingData.name, buildingData.detail, buildingData.isFavourite])
        self.database.close()
        return succeed
    }
    
    func deleteData(id:String) -> Bool{
        self.database.open()
        var sqlStr = "DELETE FROM BUILDING WHERE NUM = ?"
        self.database.executeUpdate(sqlStr, withArgumentsInArray: [id])
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [id])
        self.database.close()
        return succeed
    }
    
    func selectAll() -> [BuildingData] {
        self.database.open()
        var buildingData = [BuildingData]()
        let sqlStr = "SELECT * FROM BUILDING"
        let rs = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        var i = 0
        while rs.next(){
            buildingData[i].detail = rs.stringForColumn("DETAIL")
            buildingData[i].name = rs.stringForColumn("NAME")
            buildingData[i].id = rs.stringForColumn("NUM")
            buildingData[i].isFavourite = rs.stringForColumn("ISFAVOURITE")
            i = i + 1
        }
        self.database.close()
        return buildingData
    }
    
    func insertInHistory(str:String) -> Bool {
        self.database.open()
        let sqlStr = "INSERT INTO HISTORY VALUES (?)"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [str])
        self.database.close()
        return succeed
    }
    
    func clearHistory() -> Bool {
        self.database.open()
        let sqlStr = "DELETE FROM HISTORY"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [])
        self.database.close()
        return succeed
    }
    
    func deleteHistory(str:String) -> Bool {
        self.database.open()
        let sqlStr = "DELETE FROM HISTORY WHERE STR = ?"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [str])
        self.database.close()
        return succeed
    }
    
    func loadHistory() -> [String] {
        self.database.open()
        let sqlStr = "SELECT * FROM HISTORY"
        let rs =  self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        var history:[String] = [String]()
        var i = 0
        while rs.next(){
            history.append(rs.stringForColumn("STR"))
            i = i + 1
        }
        self.database.close()
        return history
    }
    
    
}
