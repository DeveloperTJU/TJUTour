//
//  MenuViewController.swift
//  掌上天大
//
//  Created by zyf on 16/7/5.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var selectedMenuItem : Int = 0
    var mainTableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  tableViewFrame = CGRectMake(self.view.bounds.width * 0.2, self.view.bounds.height * 0.5 - 75, self.view.bounds.width * 0.4, 150)
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        mainTableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.scrollEnabled = false
        
        let homepageButton = UIButton(type: .System)
        homepageButton.frame =  CGRectMake(self.view.bounds.width * 0.2 - 25, self.view.bounds.height * 0.5 - 60, 22, 22)
        homepageButton.setBackgroundImage(UIImage(named: "主页")!, forState: .Normal)
        homepageButton.addTarget(self, action: #selector(MyMenuTableViewController.hompage(_:)), forControlEvents: .TouchUpInside)
        let favpageButton = UIButton(type: .System)
        favpageButton.frame =  CGRectMake(self.view.bounds.width * 0.2 - 25, self.view.bounds.height * 0.5 - 10, 22, 22)
        favpageButton.setBackgroundImage(UIImage(named: "收藏")!, forState: .Normal)
        favpageButton.addTarget(self, action: #selector(MyMenuTableViewController.favpage(_:)), forControlEvents: .TouchUpInside)
        let setupButton = UIButton(type: .System)
        setupButton.frame =  CGRectMake(self.view.bounds.width * 0.2 - 25, self.view.bounds.height * 0.5 + 40, 22, 22)
        setupButton.setBackgroundImage(UIImage(named: "设定")!, forState: .Normal)
        setupButton.addTarget(self, action: #selector(MyMenuTableViewController.setup(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(mainTableView)
        self.view.addSubview(homepageButton)
        self.view.addSubview(favpageButton)
        self.view.addSubview(setupButton)

        
    }
    
    func hompage(button:UIButton) {
        self.revealViewController().pushFrontViewController(HomeContainerViewController(), animated: true)
    }
    
    func favpage(button:UIButton) {
        self.revealViewController().pushFrontViewController(FavoriteContainerViewController(), animated: true)
    }
    
    func setup(button:UIButton) {
        self.revealViewController().pushFrontViewController(SetupContainerViewController(), animated: true)
    }
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 3
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        switch indexPath.row{
        case 0:
            cell!.textLabel?.text = "首页"
        case 1:
            cell!.textLabel?.text = "收藏"
        case 2:
            cell!.textLabel?.text = "设置"
        default:
            break
        }
        return cell!
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        var destViewController:SWRevealViewController!
        switch (indexPath.row) {
        case 0:
            destViewController = HomeContainerViewController()
        case 1:
            destViewController = FavoriteContainerViewController()
        default:
            destViewController = SetupContainerViewController()
            break
        }
        self.revealViewController().pushFrontViewController(destViewController, animated: true)
    }



}
