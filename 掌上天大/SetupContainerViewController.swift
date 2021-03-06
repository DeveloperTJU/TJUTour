//
//  SetupContainerViewController.swift
//  掌上天大
//
//  Created by zyf on 16/6/30.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class SetupContainerViewController: SWRevealViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置侧栏菜单
        self.setRearViewController(MyMenuTableViewController(), animated: true)
        
        //设置主页面
        let a = UINavigationController(rootViewController: SetupViewController())
        self.setFrontViewController(a, animated: true)
        self.rearViewRevealWidth = self.view.bounds.width * 0.5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.Portrait
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
