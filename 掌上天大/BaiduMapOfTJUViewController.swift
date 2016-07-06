//
//  BaiduMapOfTJUViewController.swift
//  掌上天大
//
//  Created by xue on 16/6/29.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class BaiduMapOfTJUViewController: UIViewController, BMKMapViewDelegate, BMKPoiSearchDelegate  {
    let leftBottom = CLLocationCoordinate2D(latitude: 38.99473,longitude: 117.303725)
    let rightTop = CLLocationCoordinate2D(latitude:39.013053, longitude: 117.334033)
    var curPosIndex: NSInteger = 0
    var _mapView: BMKMapView?
    var _locService: BMKLocationService?
    var poiSearch: BMKPoiSearch!
    var currPageIndex: Int32 = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        let region = self.getRegion()
        _mapView?.setRegion(region, animated: true)
        _mapView?.limitMapRegion = region
        _mapView?.isSelectedAnnotationViewFront = true
        
        poiSearch = BMKPoiSearch()
        currPageIndex = 0
        self.view.addSubview(_mapView!)
    }
    
    func getRegion() -> BMKCoordinateRegion{
        let center = CLLocationCoordinate2D(latitude: (rightTop.latitude+leftBottom.latitude)/2, longitude: (rightTop.longitude+leftBottom.longitude)/2)
        
        let latitudeDelta = (rightTop.latitude - leftBottom.latitude)
        let longitudeDelta = (rightTop.longitude - leftBottom.longitude)
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
        self.sendPoiSearchRequest()
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        poiSearch.delegate = self
        
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       // _locService?.delegate = self
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
        poiSearch.delegate = nil
    }
    
    // MARK: - BMKMapViewDelegate
    
    func mapView(mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        _mapView!.removeOverlays(_mapView?.overlays)
        //_mapView!.removeAnnotations(_mapView!.annotations)
        //let marker = BMKGroundOverlay()
        //marker.pt = mapPoi.pt
        //self._mapView?.centerCoordinate = mapPoi.pt
        //_mapView.
        //_mapView?.addOverlay(marker)
        //_mapView!.showAnnotations(_mapView!.annotations, animated: true)
        let index = BuildingDict[mapPoi.text]
        if index != nil {
            let detailVC = DetailViewController()
            detailVC.buildingIndex = index;
           self.navigationController?.pushViewController(detailVC, animated: true)
           // addBuildingInfoView(index!, details:true)
        }
        else{
            _mapView?.centerCoordinate = mapPoi.pt
        }
    }
    
 //   func didSelectAnnotationView:(BMKAnnotationView *)
//    func addBuildingInfoView(index: NSInteger, details: Bool){
//        let mainSize = UIScreen.mainScreen().bounds.size
//        let height: CGFloat = 80
//        let frame = CGRect(x: 0, y: mainSize.height-height, width: mainSize.width, height: height)
//        let buildingInfoView = UIView(frame: frame)
//        buildingInfoView.backgroundColor = .grayColor()
//        
//        let frame1 = CGRect(x:0, y:0, width: frame.width,  height: 19)
//        let down = UIButton(frame: frame1)
//        down.backgroundColor = .whiteColor()
//        down.setTitle("hehe", forState:UIControlState.Normal)
//        down.setTitleShadowColor(UIColor.blueColor(),forState:.Normal)
//        let frame2 = CGRect(x:0, y:20, width:frame.width-20, height:frame.height-20)
//        let label = UILabel(frame: frame2)
//        label.backgroundColor = .whiteColor()
//        label.text = Buildings[index].name
//        label.textAlignment = NSTextAlignment.Center
//        
//        buildingInfoView.addSubview(down)
//        buildingInfoView.addSubview(label)
//        self.view.addSubview(buildingInfoView)
//    }
//    func startLocation() {
//        print("进入普通定位态");
//        _locService?.startUserLocationService()
//        _mapView?.showsUserLocation = false//先关闭显示的定位图层
//        _mapView?.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//        _mapView?.showsUserLocation = true//显示定位图层
//    }

    
//    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
//        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
//        _mapView?.updateLocationData(userLocation)
//    }
    
    func sendPoiSearchRequest() {
        let bound = BMKBoundSearchOption()
        bound.leftBottom = self.leftBottom
        bound.rightTop = self.rightTop
        if self.curPosIndex == -1 {
            bound.keyword = ""
        }
        else{
            bound.keyword = Buildings[self.curPosIndex].nameinmap
        }
        bound.pageIndex = currPageIndex
        bound.pageCapacity = 10
        self.curPosIndex = -1
        if poiSearch.poiSearchInbounds(bound){
            print("城市内检索发送成功！")
        }else {
            print("城市内检索发送失败！")
        }
    }
    // MARK: - BMKPoiSearchDelegate
    /**
     *返回POI搜索结果
     *@param searcher 搜索对象
     *@param poiResult 搜索结果列表
     *@param errorCode 错误号，@see BMKSearchErrorCode
     */
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        print("onGetPoiResult code: \(errorCode)");
        
        // 清除屏幕中所有的 annotation
        _mapView!.removeAnnotations(_mapView!.annotations)
        if errorCode == BMK_SEARCH_NO_ERROR {
            var annotations = [BMKPointAnnotation]()
            for i in 0..<1 {
                let poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                annotations.append(item)
            }
            self._mapView?.centerCoordinate = (poiResult.poiInfoList[0] as! BMKPoiInfo).pt
            _mapView!.addAnnotations(annotations)
            //_mapView!.showAnnotations(annotations, animated: true)
        } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
            print("检索词有歧义")
        } else {
            // 各种情况的判断……
        }
    }
    
    
}