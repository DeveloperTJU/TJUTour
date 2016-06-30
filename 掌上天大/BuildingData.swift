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
    var name:String = ""//建筑名称
    var id:String = ""//建筑ID
    var positionX:String = ""//建筑在地图上的X坐标
    var positionY:String = ""//建筑在地图上的Y坐标
    
    override init(){
        super.init()
    }
    
    convenience init(images:[UIImage],name:String,description:String,id:String,positionX:String,positionY:String){
        self.init()
        self.images = images
        self.name = name
        self.description = description
        self.id = id
        self.positionX = positionX
        self.positionY = positionY

    }

}
