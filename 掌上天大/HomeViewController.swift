//
//  HomeViewController.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDataSource {
    
    var mainTableView:UITableView!
    var dataArr = [String]()                //数据源
    let backgroundImage = UIImage()
    var navigationBlurView:UIVisualEffectView!
    var backgroundBlurView:UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        let blurEffect = UIBlurEffect(style: .Light)
        self.navigationBlurView = UIVisualEffectView(effect: blurEffect)
        self.backgroundBlurView = UIVisualEffectView(effect: blurEffect)
        navigationBlurView.frame.size = CGSize(width: view.frame.width, height: 64)
        backgroundBlurView.frame.size = self.view.bounds.size
        self.navigationController?.view.addSubview(self.navigationBlurView)
        self.view.addSubview(backgroundBlurView)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = backgroundImage
        let mapButton = UIBarButtonItem(image: UIImage(named: "地图"), style: .Plain, target: self, action: Selector("openMap"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索"), style: .Plain, target: self, action: Selector("search"))
        self.navigationItem.leftBarButtonItems = [mapButton]
        self.navigationItem.rightBarButtonItems = [searchButton]
        self.navigationController!.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        
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
        } else {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width * 2 / 3, height: UIScreen.mainScreen().bounds.width * 3 / 8))
        }
        imageView.image = UIImage(named: "0")
        return imageView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (UIScreen.mainScreen().bounds.width - 20) * 9 / 16 + 15
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coverflow = iCarousel(frame: CGRectMake(10, 10, self.view.bounds.width - 20, (UIScreen.mainScreen().bounds.width - 20) * 9 / 16))
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
        //        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.navigationBlurView.alpha = (scrollView.contentOffset.y + 64) / 150
    }
}
