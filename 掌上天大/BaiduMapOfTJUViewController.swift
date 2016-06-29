//
//  BaiduMapOfTJUViewController.swift
//  掌上天大
//
//  Created by xue on 16/6/29.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaiduMapOfTJUViewController: UIViewController, BMKMapViewDelegate {
    var _mapView: BMKMapView?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var showImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let region = self.getRegion()
        _mapView?.setRegion(region, animated: true)
        _mapView?.limitMapRegion = region
        //_mapView?.removeAnnotations(_mapView!.annotations)
        
        _mapView?.showMapPoi = true
        
        self.view.addSubview(_mapView!)
        
        
        //        var mPoiSearch = BMKPoiSearch();
        //        mPoiSearch.delegate = self
        //        var citySearchOption = BMKCitySearchOption()
        //        citySearchOption.pageIndex = 0
        //        citySearchOption.pageCapacity = 20
        //citySearchOption.
    }
    
    func getRegion() -> BMKCoordinateRegion{
        let west = CLLocationCoordinate2D(latitude: 39.004659, longitude: 117.303725)
        let east = CLLocationCoordinate2D(latitude: 39.005718, longitude: 117.334033)
        let north = CLLocationCoordinate2D(latitude: 39.013053, longitude: 117.327916)
        let south = CLLocationCoordinate2D(latitude: 38.99473, longitude: 117.328607)
        
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
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func mapView(mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        print( "您点击了地图标注\(mapPoi.text)，当前经纬度:(\(mapPoi.pt.longitude),\(mapPoi.pt.latitude))，缩放级别:\(mapView.zoomLevel)，旋转角度:\(mapView.rotation)，俯视角度:\(mapView.overlooking)")
    }
    
}