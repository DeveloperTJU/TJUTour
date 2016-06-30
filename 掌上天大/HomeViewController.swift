//
//  HomeViewController.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, ENSideMenuDelegate {
    
    var mainTableView:UITableView!
    var dataArr = [String]()                //数据源
    var navigationBlurView:UIVisualEffectView!
    var backgroundBlurView:UIVisualEffectView!
    var mapButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.sideMenuController()?.sideMenu?.delegate = self
        let blurEffect = UIBlurEffect(style: .Light)
        backgroundBlurView = UIVisualEffectView(effect: blurEffect)
        backgroundBlurView.frame.size = self.view.bounds.size
        self.view.addSubview(backgroundBlurView)
        mapButton = UIBarButtonItem(image: UIImage(named: "地图"), style: .Plain, target: self, action: Selector("openMap"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索"), style: .Plain, target: self, action: Selector("search"))
        self.navigationItem.rightBarButtonItems = [searchButton]
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let tableViewFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Grouped)
        self.mainTableView.backgroundColor = .whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.view.addSubview(self.mainTableView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        
    }
    
    func loadData(){
        self.dataArr.append("123")
        self.dataArr.append("456")
        self.dataArr.append("789")
    }
    
    func openMap(){
        let nav = UINavigationController(rootViewController: mapVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func search(){
        
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let imageView: UIImageView
        if view != nil {
            imageView = view as! UIImageView
        }
        else {
            imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 2 / 3, UIScreen.mainScreen().bounds.width * 3 / 8))
        }
        imageView.image = UIImage(named: "0")
        let nameLabel = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.width * 3 / 8, UIScreen.mainScreen().bounds.width * 2 / 3, 20))
        nameLabel.text = "NAME"
        nameLabel.textColor = .whiteColor()
        nameLabel.textAlignment = .Center
        imageView.addSubview(nameLabel)
        return imageView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 110
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coverflow = iCarousel(frame: CGRectMake(10, 100, self.view.bounds.width - 20, (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 5))
        coverflow.dataSource = self
        coverflow.type = .CoverFlow
        return coverflow
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        let cell = BaseCell()
        //        cell.cellImage?.image = self.dataArr[indexPath.row].
        cell.backgroundColor = UIColor.clearColor()
        cell.cellImage.image = UIImage(named: "0")
        cell.contentView.addSubview(cell.cellImage)
        cell.selectionStyle = .None
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.leftBarButtonItems = [mapButton]
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
    
//    func sideMenuWillOpen() {
//        self.navigationItem.leftBarButtonItems = []
//    }
//    
//    func sideMenuWillClose() {
//        self.navigationItem.leftBarButtonItems = [mapButton]
        
//    }
//    
//    func sideMenuDidClose() {
//        self.navigationItem.leftBarButtonItems = [mapButton]
//    }
}
