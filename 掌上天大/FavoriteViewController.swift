//
//  FavoriteViewController.swift
//  掌上天大
//
//  Created by zyf on 16/6/27.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,ENSideMenuDelegate {
    
    
    var mainTableView:UITableView!
    let cellidentifier:String = "BaseCell"
    var navigationBlurView:UIVisualEffectView!
    var backgroundBlurView:UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.sideMenuController()?.sideMenu?.delegate = self
        let blurEffect = UIBlurEffect(style: .Light)
        backgroundBlurView = UIVisualEffectView(effect: blurEffect)
        backgroundBlurView.frame.size = self.view.bounds.size
        self.view.addSubview(backgroundBlurView)
        let tableViewFrame = self.view.bounds
        self.mainTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.view.addSubview(mainTableView)
        let leftBtn:UIBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FavoriteViewController.actionBack))
        leftBtn.title="菜单";
        leftBtn.tintColor=UIColor.whiteColor();
        self.navigationItem.leftBarButtonItem=leftBtn;
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        print(self.mainTableView.contentOffset)

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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath){
        //设置cell的显示动画为3D缩放
        //xy方向缩放的初始值为0.1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        //设置动画时间为0.25秒，xy方向缩放的最终值为1
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 5
    }
    //左滑删除
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let more = UITableViewRowAction(style: .Normal, title: "删除") { action, index in
            print("shanchu")
            
        }
        more.backgroundColor = UIColor.lightGrayColor()
        return [more]
    }

    


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = BaseCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.cellImage.image = UIImage(named: "0")
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
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (UIScreen.mainScreen().bounds.width - 20) * 9 / 16 + 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.navigationBlurView.alpha = scrollView.contentOffset.y / 120
        self.backgroundBlurView.alpha = scrollView.contentOffset.y / 120
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clearColor()
        return view
    }

    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let blurEffect = UIBlurEffect(style: .Light)
        navigationBlurView = UIVisualEffectView(effect: blurEffect)
        navigationBlurView.frame.size = CGSize(width: view.frame.width, height: 64)
        self.navigationController?.view.addSubview(self.navigationBlurView)
        self.navigationController!.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        self.navigationBlurView.alpha = self.mainTableView.contentOffset.y / 120
        self.backgroundBlurView.alpha = self.mainTableView.contentOffset.y / 120
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationBlurView.removeFromSuperview()
    }
    

}