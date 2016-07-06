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
    var connectionErrorView:UIView!
    var connectionErrorLabel:UILabel!
    var retryButton:UIButton!
    var indicator:UIActivityIndicatorView!
    var indexChanged = false
    var isDataLoaded = false
    var countdownTimer: NSTimer?
    var isCounting = false {
        willSet {
            if newValue {
                if countdownTimer != nil{
                    countdownTimer?.invalidate()
                    countdownTimer = nil
                }
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                remainingSeconds = 3
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    
    var remainingSeconds: Int = 3 {
        willSet {
            if newValue <= 0 {
                remainingSeconds = 3
                self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: .Bottom, animated: true)
                self.coverflow.scrollToItemAtIndex((coverflow.currentItemIndex + 1) % coverflow.numberOfItems, animated: true)
            }
        }
    }
    
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    func loadData() {
        self.isDataLoaded = true
        self.isCounting = true
        coverflow = iCarousel(frame: CGRectMake(10, 0, self.view.bounds.width - 20, (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 5))
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
        let blurEffect = UIBlurEffect(style: .Dark)
        backgroundBlurView = UIVisualEffectView(effect: blurEffect)
        backgroundBlurView.frame.size = self.view.bounds.size
        self.view.addSubview(backgroundBlurView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let sideButton = UIBarButtonItem(image: UIImage(named: "菜单"), style: .Plain, target: self.revealViewController(), action: Selector("revealToggle:"))
        let searchButton = UIBarButtonItem(image: UIImage(named: "搜索黑色"), style: .Plain, target: self, action: Selector("search"))
        self.navigationItem.leftBarButtonItems = [sideButton]
        self.navigationItem.rightBarButtonItems = [searchButton]
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //无连接显示error并提示重试
        connectionErrorView = UIButton(type: .Custom)
        connectionErrorView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        let errorBlurEffect = UIBlurEffect(style: .Dark)
        let errorBlurView = UIVisualEffectView(effect: errorBlurEffect)
        errorBlurView.frame.size = self.view.bounds.size
        connectionErrorView.addSubview(errorBlurView)
        
        retryButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width / 2 - 40, UIScreen.mainScreen().bounds.height / 2 - 100, 80, 80))
        retryButton.setImage(UIImage(named: "重试"), forState: .Normal)
        retryButton.setImage(UIImage(named: "重试"), forState: .Highlighted)
        retryButton.addTarget(self, action: Selector("downloadCoverImages"), forControlEvents: .TouchDown)
        connectionErrorView.addSubview(self.retryButton)
        
        connectionErrorLabel = UILabel(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height / 2 - 20, UIScreen.mainScreen().bounds.width - 40, 60))
        connectionErrorLabel.textAlignment = .Center
        connectionErrorLabel.textColor = .whiteColor()
        connectionErrorLabel.numberOfLines = 0
        connectionErrorView.addSubview(connectionErrorLabel)
        self.view.addSubview(connectionErrorView)
        self.revealViewController().panGestureRecognizer().enabled = false
        let frame = CGRectMake(self.view.bounds.size.width/2 - 5, self.view.bounds.size.height/2 - 60, 10, 10)
        indicator = UIActivityIndicatorView(frame: frame)
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.color = UIColor.grayColor()
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        downloadCoverImages()
    }
    
    func downloadCoverImages(){
        if Buildings.count <= 0{
            indicator.startAnimating()
            retryButton.removeFromSuperview()
            connectionErrorLabel.text = "正在获取数据..."
            self.navigationController?.navigationBarHidden = true
            let url = "index.php/Home/BuildingData/getAllData"
            RequestAPI.POST(url, body: [], succeed:{ (task:NSURLSessionDataTask!, responseObject:AnyObject?) -> Void in
                let resultDict = try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)
                let arr = resultDict["modelArr"] as! NSArray
                Buildings = [BuildingData]()
                var i : NSInteger = 0
                for data in arr{
                    Buildings.append(BuildingData(id: data["id"] as! String, nameinmap: data["nameinmap"] as! String, name: data["name"] as! String, detail: data["description"] as! String))
                    BuildingDict[data["nameinmap"] as! String] = i
                    i += 1
                }
                let fav = DatabaseService.sharedInstance.selectFavorite()
                for data in fav{
                    for build in Buildings{
                        if data.id == build.id{
                            build.isFavourite = "YES"
                            break
                        }
                    }
                }
                self.connectionErrorView.removeFromSuperview()
                self.revealViewController().panGestureRecognizer().enabled = true
                self.navigationController?.navigationBarHidden = false
                self.loadData()
                self.indicator.stopAnimating()
            }) { (task:NSURLSessionDataTask?, error:NSError?) -> Void in
                self.indicator.stopAnimating()
                self.connectionErrorView.addSubview(self.retryButton)
                self.connectionErrorLabel.text = "网络无连接\n请重试"
            }
        }
    }
    
    func search(){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    func openSide(){
        self.navigationController?.pushViewController(HomeContainerViewController(), animated: true)
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
        return imageView
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        if self.mainTableView != nil && indexChanged{
            indexChanged = false
            remainingSeconds = 3
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
        return section == 0 ? (UIScreen.mainScreen().bounds.width - 20) * 3 / 8 + 41 : 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 5 : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            coverflow.contentOffset = CGSize(width: 0, height: 30)
            return coverflow
        }
        else if section == 1{
            return BuildingNameView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30), name: Buildings[self.coverflow.currentItemIndex].name)
        }
        else{
            return UIView(frame: CGRectMake(0, 0, 0, 0))
        }
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
        detailVC.building = Buildings[coverflow.currentItemIndex]
        detailVC.initIndex = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.navigationBlurView.alpha = scrollView.contentOffset.y / 120
        self.backgroundBlurView.alpha = scrollView.contentOffset.y / UIScreen.mainScreen().bounds.size.height
        self.title = self.mainTableView.contentOffset.y > 100 ? "掌上天大" : ""
        //用户浏览更多图片时推迟切换轮播图
        remainingSeconds = 10
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let blurEffect = UIBlurEffect(style: .Dark)
        navigationBlurView = UIVisualEffectView(effect: blurEffect)
        navigationBlurView.frame.size = CGSize(width: view.frame.width, height: 64)
        self.navigationController?.view.addSubview(self.navigationBlurView)
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = NavigationBarFont
        self.navigationController!.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        if isDataLoaded{
            self.navigationBlurView.alpha = self.mainTableView.contentOffset.y / 120
            self.backgroundBlurView.alpha = self.mainTableView.contentOffset.y / UIScreen.mainScreen().bounds.size.height
            self.title = self.mainTableView.contentOffset.y > 100 ? "掌上天大" : ""
        }
        else{
            self.navigationBlurView.alpha = 0
            self.backgroundBlurView.alpha = 0
            self.title = ""
        }
        if isDataLoaded{
            self.isCounting = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationBlurView.removeFromSuperview()
        self.navigationController?.navigationBar.tintColor = .None
        if isDataLoaded{
            self.isCounting = false
        }
    }
    
}
