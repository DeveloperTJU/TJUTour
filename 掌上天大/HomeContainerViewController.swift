//
//  HomeContainerViewController.swift
//  掌上天大
//
//  Created by zyf on 16/6/30.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class HomeContainerViewController: SWRevealViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置侧栏菜单
        self.setRearViewController(MyMenuTableViewController(), animated: true)
        let homeVC = HomeViewController()
        self.setFrontViewController(UINavigationController(rootViewController: homeVC), animated: true)
        if Buildings.count > 0{
            homeVC.loadData()
        }
        else{
            let url = "index.php/Home/BuildingData/getAllData"
            RequestAPI.POST(url, body: [], succeed:{ (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                
                let arr = resultDict["modelArr"] as! NSArray
                Buildings = [BuildingData]()
                var i : NSInteger = 0
                for data in arr{
                    Buildings.append(BuildingData(id: data["id"] as! String, nameinmap: data["nameinmap"] as! String, name: data["name"] as! String, detail: data["description"] as! String))
                    BuildingDict[data["nameinmap"] as! String] = i
                    DatabaseService.sharedInstance.insertData(BuildingData(id: data["id"] as! String, nameinmap: data["nameinmap"] as! String, name: data["name"] as! String, detail: data["description"] as! String, favourite: "NO"))
                    i += 1
                }
                
                homeVC.loadData()
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                //显示无连接
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
