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
                var sqlStr = "CREATE TABLE IF NOT EXISTS BUILDING(ID TEXT, NAME TEXT, NAMEINMAP TEXT, DETAIL TEXT, PRIMARY KEY(ID))"
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
    
    func insertData(buildingData : BuildingData) -> Bool{
        self.database.open()
        let sqlStr = "INSERT INTO BUILDING VALUES (?, ? ,? ,? )"
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [buildingData.id, buildingData.name, buildingData.nameinmap, buildingData.detail])
        self.database.close()
        return succeed
    }
    
    func deleteData(id:String) -> Bool{
        self.database.open()
        let sqlStr = "DELETE FROM BUILDING WHERE ID = ?"
        self.database.executeUpdate(sqlStr, withArgumentsInArray: [id])
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: [id])
        self.database.close()
        print("delete\(id)")
        return succeed
    }
    
    //选择被收藏的建筑
    func selectFavorite() -> [BuildingData] {
        self.database.open()
        var buildingData = [BuildingData]()
        let sqlStr = "SELECT * FROM BUILDING "
        let rs = self.database.executeQuery(sqlStr, withArgumentsInArray: [])
        while rs.next(){
            let favorite = BuildingData(id: rs.stringForColumn("ID"), nameinmap: rs.stringForColumn("NAMEINMAP"), name: rs.stringForColumn("NAME"), detail: rs.stringForColumn("DETAIL"), isFavourite: "YES")
            print("selecefavorite\(favorite.id)")
            buildingData.append(favorite)
        }
        self.database.close()
        
        return buildingData
    }
    
    //取消某个建筑的收藏
    func cancelFavouite(id:String) {
        self.database.open()
        let sqlStr = "UPDATE BUILDING SET FAVOURITE = ? WHERE ID = ?"
        print(id)
        let succeed = self.database.executeUpdate(sqlStr, withArgumentsInArray: ["NO",id])
        print(self.database.lastErrorMessage())
        self.database.close()

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
    
//    func loadFavorite()  {
//        self.database.open()
//        let sqlStr = "SELECT * FROM BUILDING WHERE FAVORITE = 1"
//        let rs =  self.database.executeQuery(sqlStr, withArgumentsInArray: [])
//        while rs.next(){
//            
//        }
//    }
    
    
}
