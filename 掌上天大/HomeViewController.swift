//
//  HomeViewController.swift
//  掌上天大
//
//  Created by hui on 16/6/24.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit
protocol SearchPosInMap{
    func sendPoiSearchRequest()
}
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate {
    var delegate: SearchPosInMap?
    
    var mainTableView:UITableView!
    var coverflow:iCarousel!
    var navigationBlurView:UIVisualEffectView!
    var backgroundBlurView:UIVisualEffectView!
    var indexChanged = false
    var isDataLoaded = false
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData() {
        self.isDataLoaded = true
        coverflow = iCarousel(frame: CGRectMake(10, 100, self.view.bounds.width - 20, (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 5))
        coverflow.dataSource = self
        coverflow.delegate = self
        coverflow.type = .CoverFlow
        coverflow.scrollToItemAtIndex((Buildings.count - 1) / 2, animated: false)
        let tableViewFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        self.mainTableView = UITableView(frame: tableViewFrame, style: .Grouped)
        self.mainTableView.backgroundColor = .whiteColor()
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.backgroundColor = .clearColor()
        self.mainTableView.separatorStyle = .None
        self.view.addSubview(self.mainTableView)
        for i in 0 ..< Buildings.count{
            Buildings[i].getCoverImage()
        }
        coverflow.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let blurEffect = UIBlurEffect(style: .Light)
        backgroundBlurView = UIVisualEffectView(effect: blurEffect)
        backgroundBlurView.frame.size = self.view.bounds.size
        self.view.addSubview(backgroundBlurView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let mapButton = UIBarButtonItem(image: UIImage(named: "地图"), style: .Plain, target: self, action: Selector("openMap"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索"), style: .Plain, target: self, action: Selector("search"))
        self.navigationItem.leftBarButtonItems = [mapButton]
        self.navigationItem.rightBarButtonItems = [searchButton]
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func openMap(){
        mapVC.curPosIndex = coverflow.currentItemIndex
        self.navigationController?.pushViewController(mapVC, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    func search(){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
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
        imageView.image = Buildings[index].getCoverImage()
        let nameLabel = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.width * 3 / 8, UIScreen.mainScreen().bounds.width * 2 / 3, 20))
        nameLabel.text = Buildings[index].name
        nameLabel.textColor = .whiteColor()
        nameLabel.textAlignment = .Center
        imageView.addSubview(nameLabel)
        return imageView
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        if self.mainTableView != nil && indexChanged{
            indexChanged = false
            Buildings[coverflow.currentItemIndex].getImages()
            self.mainTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        indexChanged = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 1{
            return 0
        }
        return Buildings.count <= 0 ? 0 : Buildings[self.coverflow.currentItemIndex].getImageCount()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 110 : 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 5 : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? coverflow : UIView()
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) ->UITableViewCell{
        if indexPath.section != 1{
            return UITableViewCell()
        }
        let cell = BaseCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.cellImage.image = Buildings[self.coverflow.currentItemIndex].getImages()[indexPath.row]
        cell.contentView.addSubview(cell.cellImage)
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 1 ? (UIScreen.mainScreen().bounds.width - 20) * 9 / 16 + 10 : 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailViewController()
        detailVC.building = Buildings[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.navigationBlurView.alpha = scrollView.contentOffset.y / 120
        self.backgroundBlurView.alpha = scrollView.contentOffset.y / 120
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let blurEffect = UIBlurEffect(style: .Light)
        navigationBlurView = UIVisualEffectView(effect: blurEffect)
        navigationBlurView.frame.size = CGSize(width: view.frame.width, height: 64)
        self.navigationController?.view.addSubview(self.navigationBlurView)
        self.navigationController!.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        self.navigationBlurView.alpha = isDataLoaded ? self.mainTableView.contentOffset.y / 120 : 0
        self.backgroundBlurView.alpha = isDataLoaded ? self.mainTableView.contentOffset.y / 120 : 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationBlurView.removeFromSuperview()
    }
    
}
