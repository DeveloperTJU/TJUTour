//
//  FavoriteViewController.swift
//  掌上天大
//
//  Created by zyf on 16/6/27.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    var mainTableView:UITableView!
    let cellidentifier:String = "BaseCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableViewFrame = self.view.bounds
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.mainTableView.backgroundColor = UIColor.whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.backgroundColor = UIColor.redColor()
        self.view.addSubview(mainTableView)
        let leftBtn:UIBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "actionBack")
        leftBtn.title="菜单";
        leftBtn.tintColor=UIColor.whiteColor();
        self.navigationItem.leftBarButtonItem=leftBtn;
        
        // Do any additional setup after loading the view.
    }
    
    func actionBack(){
        if self.isSideMenuOpen(){
            self.hideSideMenuView()
            
        }
        else {
            self.showSideMenuView()

        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.width * 9 / 16
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = BaseCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.cellImage.image = UIImage(named: "3")
        cell.contentView.addSubview(cell.cellImage)
        cell.detailLabel.text = "test"
        cell.detailLabel.textColor = UIColor.redColor()
        cell.contentView.addSubview(cell.detailLabel)
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 10))
        view.backgroundColor = UIColor.clearColor()
        cell.addSubview(view)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    

}
