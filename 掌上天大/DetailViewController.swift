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
    var likeArray : [NSArray]?
    var contentTextView:UITextView!
    var likeButton:UIButton!
    var goodButton:UIButton!
    var isLike:String = "1"
    var isGood:String = "1"
    var scrollview:UIScrollView!
    var pagecontrol:UIPageControl!
    var timer:NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = building.name
        self.view.backgroundColor = UIColor.grayColor()

        //给导航增加item
        let rightItem = UIBarButtonItem(title: "3D模式", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DetailViewController.threeDItem(_:)))
        rightItem.title = "3D模式"
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        //轮播图
        self.scrollview = UIScrollView()
        self.pagecontrol = UIPageControl()
        self.scrollview.backgroundColor = UIColor.whiteColor()
        self.scrollview.frame = CGRect(x: 20, y: 90, width: (self.view.frame.size.width - 40), height: 190)
        self.pagecontrol.frame = CGRect(x: 200, y: 240, width: 20, height: 20)
        initView()
        self.view.addSubview(self.scrollview)
        self.view.addSubview(self.pagecontrol)
        
        
        //详细信息
        self.contentTextView = UITextView(frame: CGRectMake(15, 270, self.view.frame.size.width - 30, self.view.frame.size.height - 380))
        
        self.contentTextView.layer.borderColor = UIColor(red: 60/255, green: 40/255, blue: 129/255, alpha: 1).CGColor;
        self.contentTextView.editable = false
        self.contentTextView.delegate = self
        self.contentTextView.backgroundColor = UIColor.grayColor()
        
        let comment_message_style = NSMutableParagraphStyle()
        comment_message_style.firstLineHeadIndent = 12.0
        comment_message_style.headIndent = 10.0
        let comment_message_indent = NSMutableAttributedString(string:
            building.detail)
        comment_message_indent.addAttribute(NSParagraphStyleAttributeName,
                                            value: comment_message_style,
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSFontAttributeName,
                                            value: UIFont.systemFontOfSize(15),
                                            range: NSMakeRange(0, comment_message_indent.length))
        comment_message_indent.addAttribute(NSForegroundColorAttributeName,
                                            value: UIColor.whiteColor(),
                                            range: NSMakeRange(0, comment_message_indent.length))
        self.contentTextView.attributedText = comment_message_indent
        
        self.view.addSubview(self.contentTextView)
        
        
        //喜欢按钮
        if(building.isFavourite=="NO"){
            self.isLike = "1"
        }
        self.likeButton = UIButton()
        likeButton.frame=CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width / 2, 60)
        if(self.isLike == "0"){
            self.likeButton.setImage(UIImage(named: "3"), forState: .Normal)
            self.likeButton.setImage(UIImage(named: "3"), forState: .Highlighted)
            self.likeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
        }
        else{
            self.likeButton.setImage(UIImage(named: "2"), forState: .Normal)
            self.likeButton.setImage(UIImage(named: "2"), forState: .Highlighted)
            self.likeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
        }
        self.likeButton.addTarget(self, action: Selector("like:"), forControlEvents: .TouchDown)
        self.view.addSubview(self.likeButton)
        
        //点赞按钮
        self.goodButton = UIButton()
        self.goodButton.frame=CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60, self.view.frame.size.width / 2, 60)
        if(self.isGood == "0"){
            self.goodButton.setImage(UIImage(named: "2"), forState: .Normal)
            self.goodButton.setImage(UIImage(named: "2"), forState: .Highlighted)
            self.goodButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
        }
        else{
            self.goodButton.setImage(UIImage(named: "3"), forState: .Normal)
            self.goodButton.setImage(UIImage(named: "3"), forState: .Highlighted)
            self.goodButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
        }
        self.goodButton.addTarget(self, action: Selector("good:"), forControlEvents: .TouchDown)
        self.view.addSubview(self.goodButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func threeDItem(right:UIBarButtonItem)
    {
        //连接3D视图
        
    }
    
    func like(button:UIButton){
        print("like")
        if(self.isLike == "0"){
            self.likeButton.setImage(UIImage(named: "2"), forState: .Normal)
            self.likeButton.setImage(UIImage(named: "2"), forState: .Highlighted)
            self.likeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
            self.isLike = "1"
        }
        else{
            self.likeButton.setImage(UIImage(named: "3"), forState: .Normal)
            self.likeButton.setImage(UIImage(named: "3"), forState: .Highlighted)
            self.likeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
            self.isLike = "0"
        }
        

    }
    
    func good(button:UIButton){
        print("good")
        if(self.isGood == "0"){
            self.goodButton.setImage(UIImage(named: "3"), forState: .Normal)
            self.goodButton.setImage(UIImage(named: "3"), forState: .Highlighted)
            self.goodButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
            self.isGood = "1"
        }
        else{
            self.goodButton.setImage(UIImage(named: "2"), forState: .Normal)
            self.goodButton.setImage(UIImage(named: "2"), forState: .Highlighted)
            self.goodButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: self.view.frame.size.width / 6, bottom: 5, right: self.view.frame.size.width / 6)
            self.isGood = "0"
        }
    }
    
    
    
    
    func initView(){
        let image_W:CGFloat = self.scrollview.frame.size.width
        let image_H:CGFloat = self.scrollview.frame.size.height
        var image_Y:CGFloat = 0
        var totalCount:NSInteger = 5
        for index in 0..<totalCount{
            var imageView:UIImageView = UIImageView()
            let image_X:CGFloat = CGFloat(index) * image_W
            imageView.frame = CGRectMake(image_X, image_Y, image_W, image_H)
            let name:NSString = NSString(format:"%d",index+1)
            imageView.image = UIImage(named:name as String)
            self.scrollview.showsHorizontalScrollIndicator = false
            self.scrollview.addSubview(imageView)
        }
        self.view.addSubview(self.pagecontrol)
        let content_W:CGFloat = image_W * CGFloat(totalCount)
        self.scrollview.contentSize = CGSizeMake(content_W, 0)
        self.scrollview.pagingEnabled = true;
        self.scrollview.delegate = self
        self.pagecontrol.numberOfPages = totalCount
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
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "nextImage:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
    }
    func removeTimer(){
        self.timer.invalidate()
    }
    func nextImage(sender:AnyObject!){
        var page:Int = self.pagecontrol.currentPage
        if(page == 4){
            page = 0
        }
        else{
            ++page
        }
        let x:CGFloat = CGFloat(page) * self.scrollview.frame.size.width
        self.scrollview.contentOffset = CGPointMake(x, 0)
    }
    
//    func load () {
//        var likes : [NSArray] = []
//        
//        let stringsArray = NSUserDefaults.standardUserDefaults().objectForKey("likeArray") as [String]?
//        
//        if let array = stringsArray {
//            for string in array {
//                var url = NSURL(string: string)
//                urls.append(url!) //no null check
//            }
//        }
//        
//        self.likeArray = likes
//    }
//    
//    func save () {
//        var strings : [String] = []
//        
//        if let array = self.likeArray {
//            for like in array {
//                let string = String(like)
//                strings.append(string)
//            }
//        }
//        
//        NSUserDefaults.standardUserDefaults().setObject(strings, forKey: "likeArray")
//    }
}