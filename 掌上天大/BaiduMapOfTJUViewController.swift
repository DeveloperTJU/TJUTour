//
//  BaiduMapOfTJUViewController.swift
//  掌上天大
//
//  Created by xue on 16/6/29.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaiduMapOfTJUViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate {
    let west = CLLocationCoordinate2D(latitude: 39.004659, longitude: 117.303725)
    let east = CLLocationCoordinate2D(latitude: 39.005718, longitude: 117.334033)
    let north = CLLocationCoordinate2D(latitude: 39.013053, longitude: 117.327916)
    let south = CLLocationCoordinate2D(latitude: 38.99473, longitude: 117.328607)
    
    var _mapView: BMKMapView?
    var _locService: BMKLocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "<返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaiduMapOfTJUViewController.actionBack))
        leftBtn.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view, typically from a nib.
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        let region = self.getRegion()
        _mapView?.setRegion(region, animated: true)
        _mapView?.limitMapRegion = region
        //_mapView?.showMapPoi = true
        
        _locService = BMKLocationService()
        //_locService?.allowsBackgroundLocationUpdates = true
        self.startLocation()
        self.view.addSubview(_mapView!)
        
        self.navigationItem.leftBarButtonItem = leftBtn
        
    }
    
    
    func getRegion() -> BMKCoordinateRegion{
        let center = CLLocationCoordinate2D(latitude: (north.latitude+south.latitude)/2, longitude: (east.longitude+west.longitude)/2)
        
        let latitudeDelta = (north.latitude - south.latitude)
        let longitudeDelta = (east.longitude - west.longitude)
        let span = BMKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let region = BMKCoordinateRegion(center: center, span: span)
        return region
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _locService?.delegate = self
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _locService?.delegate = self
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
    }
    
    // MARK: - BMKMapViewDelegate
    
    func mapView(mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        print( "您点击了地图标注\(mapPoi.text)，当前经纬度:(\(mapPoi.pt.longitude),\(mapPoi.pt.latitude))，缩放级别:\(mapView.zoomLevel)，旋转角度:\(mapView.rotation)，俯视角度:\(mapView.overlooking)")
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func startLocation() {
        print("进入普通定位态");
        _locService?.startUserLocationService()
        _mapView?.showsUserLocation = false//先关闭显示的定位图层
        _mapView?.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView?.showsUserLocation = true//显示定位图层
    }

    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        _mapView?.updateLocationData(userLocation)
    }
    
    func actionBack(){
        self.presentViewController(MyNavigationController(menuViewController: MyMenuTableViewController(), contentViewController:HomeViewController()), animated: true, completion: nil)
    }
}