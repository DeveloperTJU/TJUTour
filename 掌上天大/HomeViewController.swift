//
//  HomeViewController.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate, ENSideMenuDelegate {
    
    var mainTableView:UITableView!
    var coverflow:iCarousel!
    var navigationBlurView:UIVisualEffectView!
    var backgroundBlurView:UIVisualEffectView!
    var mapButton:UIBarButtonItem!
    var indexChanged = false
    
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
        mapButton = UIBarButtonItem(image: UIImage(named: "地图"), style: .Plain, target: self, action: Selector("openMap"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索"), style: .Plain, target: self, action: Selector("search"))
        self.navigationItem.rightBarButtonItems = [searchButton]
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        coverflow = iCarousel(frame: CGRectMake(10, 100, self.view.bounds.width - 20, (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 5))
        coverflow.scrollToItemAtIndex((Buildings.count - 1) / 2, animated: false)
        coverflow.dataSource = self
        coverflow.delegate = self
        coverflow.type = .CoverFlow
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
    
    func openMap(){
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func search(){
        
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return Buildings.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let imageView: UIImageView
        if view != nil {
            imageView = view as! UIImageView
        }
        else {
            imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 2 / 3, UIScreen.mainScreen().bounds.width * 3 / 8))
        }
        if Buildings[self.coverflow.currentItemIndex].images.count == 0{
            imageView.image = UIImage(named: "0")
        }
        else{
            imageView.image = Buildings[self.coverflow.currentItemIndex].images[0]
        }
        let nameLabel = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.width * 3 / 8, UIScreen.mainScreen().bounds.width * 2 / 3, 20))
        nameLabel.text = Buildings[self.coverflow.currentItemIndex].name
        nameLabel.textColor = .whiteColor()
        nameLabel.textAlignment = .Center
        imageView.addSubview(nameLabel)
        return imageView
    }
    
//    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
//        if self.mainTableView != nil{
//            self.mainTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
//        }
//    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        if self.mainTableView != nil && indexChanged{
            indexChanged = false
            self.mainTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        }
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        indexChanged = true
        if self.mainTableView != nil{
//            self.mainTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Buildings.count == 0 ? 0 : Buildings[self.coverflow.currentItemIndex].images.count
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
        return coverflow
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        let cell = BaseCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.cellImage.image = Buildings[self.coverflow.currentItemIndex].images[indexPath.row]
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
    
}
