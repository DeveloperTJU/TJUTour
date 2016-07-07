//
//  3DViewController.swift
//  掌上天大
//
//  Created by zyf on 16/7/6.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class threeDViewController: UIViewController,GVRWidgetViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panoView = GVRPanoramaView(frame: CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height))
        panoView.delegate = self
        panoView.enableCardboardButton = true
        panoView.enableFullscreenButton = true
        panoView.loadImage(UIImage(named: "4"), ofType:.StereoOverUnder)
        self.view.addSubview(panoView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
