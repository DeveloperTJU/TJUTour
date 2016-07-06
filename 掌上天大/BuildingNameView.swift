//
//  BuildingNameView.swift
//  掌上天大
//
//  Created by hui on 16/7/5.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BuildingNameView: UIView {
    
    let nameLabel = UILabel(frame: CGRectMake(15, 0, UIScreen.mainScreen().bounds.width - 30, 30))
    var dx:CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, name:String) {
        self.init()
        self.drawLabel(name)
    }
    
    override func drawRect(rect: CGRect){
        let path = CGPathCreateMutable()
        let context =  UIGraphicsGetCurrentContext()!
        let y = self.frame.size.height / 2
        CGContextSetAllowsAntialiasing(context, true)
        CGPathMoveToPoint(path, nil, 10, y)
        CGPathAddLineToPoint(path, nil, UIScreen.mainScreen().bounds.width / 2 - dx, y)
        CGPathMoveToPoint(path, nil, UIScreen.mainScreen().bounds.width / 2 + dx + 15, y)
        CGPathAddLineToPoint(path, nil, UIScreen.mainScreen().bounds.width - 10, y)
        CGContextAddPath(context, path)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextStrokePath(context)
    }

    func drawLabel(name:String){
        nameLabel.text = Buildings[HomeVC.coverflow.currentItemIndex].name
        nameLabel.textColor = .whiteColor()
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont.systemFontOfSize(14)
        self.addSubview(nameLabel)
        self.backgroundColor = .clearColor()
        dx = NSString(string: nameLabel.text!).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)]).width / 2 + 5
        let mapButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width / 2 + dx - 2, 7, 15, 15))
        mapButton.setImage(UIImage(named: "地图"), forState: .Normal)
        mapButton.addTarget(self, action: Selector("openMap"), forControlEvents: .TouchDown)
        self.addSubview(mapButton)
    }
    
    func openMap(){
        mapVC.curPosIndex = HomeVC.coverflow.currentItemIndex
        HomeVC.navigationController?.pushViewController(mapVC, animated: true)
        HomeVC.navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
}
