//
//  BuildingData.swift
//  掌上天大
//
//  Created by zyf on 16/6/27.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BuildingData: NSObject {

    private var images:[UIImage] = []//摸个建筑所有图片的路径的数组
    var id:String = ""//建筑ID, 用于建筑的索引，也是其图片文件夹名称和模型文件在本地、远程的文件名
    var nameinmap = ""
    var name:String = ""//建筑名称
    var detail:String = ""//详情页的描述
    var isFavourite = "NO"//YES 或 NO
    
    override init(){
        super.init()
    }
    
    convenience init(id:String, nameinmap:String, name:String, detail:String){
        self.init()
        self.id = id
        self.nameinmap = nameinmap
        self.name = name
        self.detail = detail
    }
    
    convenience init(id:String, nameinmap:String, name:String, detail:String, isFavourite: String){
        self.init()
        self.id = id
        self.nameinmap = nameinmap
        self.name = name
        self.detail = detail
        self.isFavourite = isFavourite
    }
    

    func getImageCount() -> Int{
        return images.count
    }
    
    func getCoverImage() -> UIImage{
        if images.count == 0{
            let image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(RequestClient.URL)/building_pictures/\(id)/0.jpg")!)!)
            images.append(image!)
        }
        return images[0]
    }
    
    func getImages() -> [UIImage]{
        if images.count <= 1{
            images = [UIImage]()
            var i = 0
            while true{
                let data = NSData(contentsOfURL: NSURL(string: "\(RequestClient.URL)/building_pictures/\(id)/\(i).jpg")!)
                i += 1
                if data == nil{
                    break
                }
                else{
                    images.append(UIImage(data: data!)!)
                }
            }
        }
        return images
    }

}
