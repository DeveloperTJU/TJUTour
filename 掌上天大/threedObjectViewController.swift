//
//  threedObjectViewController.swift
//  掌上天大
//
//  Created by zyf on 16/7/6.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class threedObjectViewController: UIViewController,TreasureHuntRendererDelegate {
    
    var treasureHuntRenderer = TreasureHuntRenderer()
    var cardboardView = GVRCardboardView(frame: CGRectZero)
    var renderLoop:TreasureHuntRenderLoop?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.treasureHuntRenderer.delegate = self
        self.cardboardView.delegate = treasureHuntRenderer
        //self.cardboardView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.cardboardView.vrModeEnabled = true
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector("didDoubleTapView:"))
        doubleTapGesture.numberOfTouchesRequired = 2
        self.cardboardView.addGestureRecognizer(doubleTapGesture)
        self.view = self.cardboardView
        
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.renderLoop = TreasureHuntRenderLoop(renderTarget: self.cardboardView, selector: #selector(GVRCardboardView().render))
        
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        renderLoop?.invalidate()
        renderLoop = nil
        
    }
    
    func shouldPauseRenderLoop(pause: Bool) {
        renderLoop?.paused = pause
    }
    
    func didDoubleTapView(gesture: UIGestureRecognizer){
        
        cardboardView.vrModeEnabled = !cardboardView.vrModeEnabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
