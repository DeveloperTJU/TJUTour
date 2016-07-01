//
//  BuildingData.swift
//  掌上天大
//
//  Created by zyf on 16/6/27.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BuildingData: NSObject {

    var images:[UIImage] = []//摸个建筑所有图片的路径的数组
    var id:String = ""//建筑ID, 用于建筑的索引，也是其图片文件夹名称和模型文件在本地、远程的文件名
    var nameinmap = ""
    var name:String = ""//建筑名称
    var detail:String = ""//详情页的描述
    var favourite = "NO"//YES 或 NO
    
    override init(){
        super.init()
    }
    
    convenience init(id:String, name:String, detail:String){
        self.init()
        self.id = id
        self.name = name
        self.detail = detail
    }
    
    convenience init(id:String, nameinmap:String, name:String, detail:String, isHistory:String, favourite: String){
        self.init()
        self.id = id
        self.nameinmap = nameinmap
        self.name = name
        self.detail = detail
        self.favourite = favourite
    }

}
