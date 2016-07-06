//
//  RequestAPI.swift
//  Memo
//
//  Created by zyf on 16/6/8.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

typealias Succeed = (NSURLSessionDataTask!,AnyObject!)->Void
typealias Failure = (NSURLSessionDataTask!,NSError!)->Void

class RequestAPI: NSObject {
    
    //普通post网络请求
    class func POST(url:String!,body:AnyObject?,succeed:Succeed,failed:Failure) {
        let mysucceed:Succeed = succeed
        let myfailure:Failure = failed
        RequestClient.sharedInstance.POST(url, parameters: body, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            mysucceed(task,responseObject)
        }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
            myfailure(task,error)
        }
    }
    
}