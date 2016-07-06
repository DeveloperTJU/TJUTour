//
//  DetailViewController.swift
//  掌上天大
//
//  Created by Luvian on 16/6/27.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate {
    
    var building:BuildingData!
    var buildingIndex: NSInteger!
    var initIndex: Int = 0
    var likeArray : [NSArray]?
    var contentTextView:UITextView!
    var likeButton:UIButton!
    var goodButton:UIButton!
    var isLike:String = "0"
    var isGood:String = "1"
    var scrollview:UIScrollView!
    var pagecontrol:UIPageControl!
    var timer:NSTimer!
    var likeimage:UIImage!
    var likelabel:UILabel!
    var bgImageView:UIImageView!
    var vImg:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        building = Buildings[self.buildingIndex]
        self.title = building.name
        self.view.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 248/255, alpha: 1)
        self.bgImageView = UIImageView(image: UIImage(named: "background"))
        self.bgImageView.frame = self.view.bounds
        self.view.addSubview(self.bgImageView)
        
        //给导航增加item
        let mainColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = mainColor
        let rightItem = UIBarButtonItem(title: "3D模式", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailViewController.threeDItem(_:)))
        rightItem.title = "3D模式"
        self.navigationItem.rightBarButtonItem = rightItem
        let resetButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reset"))
        resetButton.title = "返回"
        self.navigationItem.leftBarButtonItem = resetButton
        
        
        //详细信息
        self.contentTextView = UITextView(frame: CGRectMake(15, (self.view.frame.size.height/4)+80, self.view.frame.size.width - 30, ((self.view.frame.size.height/4)*3)-140))
        self.contentTextView.layer.shadowColor = UIColor.blackColor().CGColor
        self.contentTextView.layer.shadowOffset = CGSizeMake(4,4)
        self.contentTextView.layer.shadowOpacity = 0.8
        self.contentTextView.layer.shadowRadius = 4
        
        self.contentTextView.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        self.contentTextView.editable = false
        self.contentTextView.delegate = self
        self.contentTextView.backgroundColor = UIColor.clearColor()
        self.contentTextView.textColor = UIColor.whiteColor()
        
        let comment_message_style = NSMutableParagraphStyle()
        comment_message_style.firstLineHeadIndent = 12.0
        comment_message_style.headIndent = 10.0
        let comment_message_indent = NSMutableAttributedString(string:
            building.detail)
        comment_message_indent.addAttribute(NSParagraphStyleAttributeName,
                                            value: comment_message_style,
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSFontAttributeName,
                                            value: UIFont(name: "HelveticaNeue-Thin", size: 15.0)!,
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSForegroundColorAttributeName,
                                            value: UIColor.whiteColor(),
                                            range: NSMakeRange(0, comment_message_indent.length))
    
        
        
        //        comment_message_indent.addAttribute(NSForegroundColorAttributeName,
        //                                            value: UIColor.whiteColor(),
        //                                            range: NSMakeRange(0, comment_message_indent.length))
        self.contentTextView.attributedText = comment_message_indent
        
        self.view.addSubview(self.contentTextView)
        
        //轮播图
        self.scrollview = UIScrollView()
        self.pagecontrol = UIPageControl()
        self.scrollview.backgroundColor = UIColor.whiteColor()
        self.scrollview.frame = CGRect(x: 15, y: 80, width: (self.view.frame.size.width - 30), height: self.view.frame.size.height/4)
        self.pagecontrol.frame = CGRect(x: (self.view.frame.size.width/2)-10, y: (self.view.frame.size.height/4)+40, width: 20, height: 20)
        initView()
        self.view.addSubview(self.scrollview)
        self.view.addSubview(self.pagecontrol)
        
        
        
        
        
        //喜欢按钮
        
        if(building.isFavourite=="NO"){
            self.isLike = "0"
        }
        else{
            self.isLike = "1"
        }
        self.likeButton = UIButton()
        likeButton.frame=CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width / 2, 60)
        if(self.isLike == "0"){
            self.likeimage = UIImage(named: "未收藏")
            self.vImg = UIImageView(image: self.likeimage)
            self.vImg.frame = CGRect(x:(self.view.frame.size.width/2) - 130,y:self.view.frame.size.height - 40,width:20,height:20)
            self.view.addSubview(self.vImg)
            self.likelabel = UILabel()
            self.likelabel.frame=CGRectMake((self.view.frame.size.width/2) - 90, self.view.frame.size.height - 40, 70, 20)
            self.likelabel.text = "收藏"
            self.likelabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
            self.likelabel.textColor = UIColor.whiteColor()
            self.view.addSubview(self.likelabel)
        }
        else{
            self.likeimage = UIImage(named: "已收藏")
            self.vImg = UIImageView(image: self.likeimage)
            self.vImg.frame = CGRect(x:(self.view.frame.size.width/2) - 130,y:self.view.frame.size.height - 40,width:20,height:20)
            self.view.addSubview(self.vImg)
            self.likelabel = UILabel()
            self.likelabel.frame=CGRectMake((self.view.frame.size.width/2) - 90, self.view.frame.size.height - 40, 70, 20)
            self.likelabel.text = "已收藏"
            self.likelabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
            self.likelabel.textColor = UIColor.whiteColor()
            self.view.addSubview(self.likelabel)
        }
        self.likeButton.addTarget(self, action: Selector("like:"), forControlEvents: .TouchDown)
        self.view.addSubview(self.likeButton)
        
        
        
        //点赞按钮
        self.goodButton = UIButton()
        self.goodButton.frame=CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60, self.view.frame.size.width / 2, 60)
        
        self.likeimage = UIImage(named: "分享")
        let vImg3 = UIImageView(image: self.likeimage)
        vImg3.frame = CGRect(x:(self.view.frame.size.width/2) + 65,y:self.view.frame.size.height - 40,width:20,height:20)
        self.view.addSubview(vImg3)
        
        self.goodButton.addTarget(self, action: Selector("good:"), forControlEvents: .TouchDown)
        self.view.addSubview(self.goodButton)
        
        let sharelabel = UILabel()
        sharelabel.textColor = UIColor.whiteColor()
        sharelabel.frame=CGRectMake((self.view.frame.size.width / 2)+105, self.view.frame.size.height - 40, 50, 20)
        sharelabel.text = "分享"
        sharelabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16.0)
        self.view.addSubview(sharelabel)
        
        
        //中间的竖线
        let line = UITextView(frame: CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 45, 0.8, 30))
        line.editable=false
        line.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).CGColor;
        line.layer.borderWidth = 0.4;
        line.layer.cornerRadius = 3;
        self.view.addSubview(line)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func threeDItem(right:UIBarButtonItem)
    {
        //连接3D视图
        self.navigationController?.pushViewController(threeDViewController(), animated: true)
        
    }
    
    func like(button:UIButton){
        if(self.isLike == "0"){
            self.vImg.image = UIImage(named: "已收藏")
            self.vImg.frame = CGRect(x:(self.view.frame.size.width/2) - 130,y:self.view.frame.size.height - 40,width:20,height:20)
            self.view.addSubview(self.vImg)
            self.isLike = "1"
            self.building.isFavourite = "YES"
            self.likelabel.text = "已收藏"
            DatabaseService.sharedInstance.insertData(building)
            Buildings[self.buildingIndex].isFavourite = "YES"
        }
        else{
            self.vImg.image = UIImage(named: "未收藏")
            self.vImg.frame = CGRect(x:(self.view.frame.size.width/2) - 130,y:self.view.frame.size.height - 40,width:20,height:20)
            self.view.addSubview(self.vImg)
            
            self.isLike = "0"
            self.building.isFavourite = "NO"
            self.likelabel.text = "收藏"
            DatabaseService.sharedInstance.deleteData(building.id)
        
            Buildings[self.buildingIndex].isFavourite = "NO"
        }
    }
    
    func good(button:UIButton){
        
    }
    
    
    
    
    func initView(){
        let image_W:CGFloat = self.scrollview.frame.size.width
        let image_H:CGFloat = self.scrollview.frame.size.height
        var image_Y:CGFloat = 0
        var allImages = self.building.getImages()
        for index in 0..<allImages.count{
            var imageView:UIImageView = UIImageView()
            let image_X:CGFloat = CGFloat(index) * image_W
            imageView.frame = CGRectMake(image_X, image_Y, image_W, image_H)
            let name:NSString = NSString(format:"%d",index+1)
            imageView.image = allImages[index]
            self.scrollview.showsHorizontalScrollIndicator = false
            self.scrollview.addSubview(imageView)
        }
        self.view.addSubview(self.pagecontrol)
        let content_W:CGFloat = image_W * CGFloat(allImages.count)
        self.scrollview.contentSize = CGSizeMake(content_W, 0)
        self.scrollview.pagingEnabled = true;
        self.scrollview.delegate = self
        self.pagecontrol.numberOfPages = allImages.count
        self.addTimer()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollviewW:CGFloat = scrollview.frame.size.width
        let x:CGFloat = scrollview.contentOffset.x
        let page:Int = (Int)((x + scrollviewW / 2) / scrollviewW)
        self.pagecontrol.currentPage = page
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        self.removeTimer()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        self.addTimer()
    }
    
    func addTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "nextImage:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
    }
    func removeTimer(){
        self.timer.invalidate()
    }
    func nextImage(sender:AnyObject!){
        var page:Int = self.pagecontrol.currentPage
        var allImages = self.building.getImages()
        if(page == (allImages.count-1)){
            page = 0
        }
        else{
            ++page
        }
        let x:CGFloat = CGFloat(page) * self.scrollview.frame.size.width
        self.scrollview.contentOffset = CGPointMake(x, 0)
    }
    
    func reset() {
        self.navigationController!.popViewControllerAnimated(true)
    }
}