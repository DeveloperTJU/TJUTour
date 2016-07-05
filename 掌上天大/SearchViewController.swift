//
//  SearchViewController.swift
//  掌上天大
//
//  Created by tjise on 16/6/25.
//  Copyright © 2016年 hui. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController ,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var searchBar:UISearchBar!
    var mainTableView:UITableView!
    var historyArr:[String] = []
    var currentArr:[BuildingData] = []
    var searchState:Int = 1//1表示历史搜索，0表示当前搜索列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setSearchBar()
        self.setMainTableView()
        self.mainTableView.userInteractionEnabled = true
        // self.mainTableView.backgroundColor = UIColor.clearColor()
    }
    
    //设置搜索条
    func setSearchBar(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "OnBackBtnClicked")
        self.navigationItem.leftBarButtonItem = leftBtn
        let frame:CGRect = CGRectMake(70, 0, self.view.bounds.width-80, 0)
        self.searchBar = UISearchBar(frame: frame)
        self.searchBar.searchBarStyle = .Minimal
        self.searchBar.delegate = self
        self.navigationItem.titleView = self.searchBar
    }
    
    
    //开始搜索时的事件响应
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            self.refreshSearchTableView(searchText)
        }else{
            self.searchState = 1
            self.mainTableView.reloadData()
        }
    }
    
    //点击历史搜索时，刷新当前搜索界面
    func refreshSearchTableView(string:String){
        let buildings = self.getAllBuildings()
        self.searchState = 0
        self.currentArr.removeAll()
        self.currentArr = self.getAllBuildings()
        self.filterContentForSearchText(string)
        //        for i in 0 ..< buildings.count{
        //            let name = buildings[i].name
        //            if name.containsString(string){
        //                let building:BuildingData = BuildingData()
        //                building.name = buildings[i].name
        //                building.id = buildings[i].id
        //                self.currentArr.append(building)
        //            }
        //        }
        self.mainTableView.reloadData()
    }
    
    
    //点击导航栏返回按钮事件
    func OnBackBtnClicked(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //设置搜索结果的tableView
    func setMainTableView(){
        //        let userDefault = NSUserDefaults.standardUserDefaults()
        //        if userDefault.objectForKey("history") == nil{
        //            let inputSet:NSArray = NSArray(array: [])
        //            userDefault.setObject(inputSet, forKey: "history")
        //        }
        //        let set:NSArray = userDefault.objectForKey("history") as! NSArray
        //        self.historyArr = set as! [String]
        self.historyArr = DatabaseService.sharedInstance.loadHistory()
        let frame:CGRect = CGRectMake(0, 10, self.view.bounds.width, self.view.bounds.height)
        self.mainTableView = UITableView(frame: frame)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.view.addSubview(mainTableView)
    }
    
    //设置tableView行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchState == 1{
            return historyArr.count + 1
        }else{
            return self.currentArr.count
        }
    }
    
    //设置tableView样式
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let frame:CGRect = CGRectMake(0, 0, self.mainTableView.bounds.width, 0)
        let cell:UITableViewCell = UITableViewCell(frame: frame)
        cell.selectionStyle = .None
        cell.backgroundColor = .clearColor()
        tableView.separatorStyle = .None
        self.mainTableView.backgroundColor = UIColor(colorLiteralRed: 239, green: 242, blue: 244, alpha: 0)
        if searchState == 1{
            if indexPath.row == 0{
                let textWidth:CGFloat = 100.0//文本标签宽度
                let textX:CGFloat = self.view.frame.width/3//文本标签x值
                let imageWidth:CGFloat = 50.0//iamgeView的宽度
                //添加文本
                let textframe:CGRect = CGRectMake(textX, 0, textWidth, 20)
                let textLabel:UILabel = UILabel(frame: textframe)
                textLabel.text = "历史搜索"
                textLabel.textColor = UIColor.grayColor()
                textLabel.textAlignment = .Center
                cell.addSubview(textLabel)
                
                //添加删除图标
                let imageFrame:CGRect = CGRectMake(textWidth+textX, 0, imageWidth, 20)
                let imageView:UIImageView = UIImageView(frame: imageFrame)
                imageView.image = UIImage(named: "删除")
                let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onDeleteHistorySearch:")
                imageView.userInteractionEnabled = true
                imageView.addGestureRecognizer(gesture)
                cell.addSubview(imageView)
                
                //添加分割线
                let textSize:CGSize = textLabel.text!.sizeWithAttributes(["sizeWithFont":textLabel.font,"forWidth":textLabel.bounds.size.width])
                let distance = (textWidth - textSize.width)/2-10//文本开始位置，与标签开始位置的间距
                
                let leftFrame:CGRect = CGRectMake(10, textSize.height/2, textX+distance-10, 2)
                let leftView:UIView = UIView(frame: leftFrame)
                leftView.backgroundColor = UIColor.blackColor()
                cell.addSubview(leftView)
                
                let centerFrame:CGRect = CGRectMake(textX+textWidth-distance, textSize.height/2, distance, 2)
                let centerView:UIView = UIView(frame: centerFrame)
                centerView.backgroundColor = UIColor.blackColor()
                cell.addSubview(centerView)
                
                let rightFrame:CGRect = CGRectMake(textX+textWidth+imageWidth, textSize.height/2, self.view.frame.width-(textX+textWidth+imageWidth)-10, 2)
                let rightView:UIView = UIView(frame: rightFrame)
                rightView.backgroundColor = UIColor.blackColor()
                cell.addSubview(rightView)
            }else{
                cell.textLabel?.drawTextInRect(CGRectMake(100, 0, self.mainTableView.bounds.width-50, 0))
                cell.textLabel?.text = "   " + historyArr[self.historyArr.count - indexPath.row]
                cell.textLabel?.textColor = UIColor.grayColor()
            }
            return cell
        }
        else if searchState == 0{
            //搜索状态，显示当前搜索
            cell.textLabel!.text = self.currentArr[indexPath.row].name
            cell.textLabel!.textColor = UIColor.grayColor()
            cell.accessoryType = .DisclosureIndicator
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    //tableView点击样式
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if searchState == 0{
            self.searchBar.resignFirstResponder()
            if historyArr.contains(self.searchBar.text!){
                historyArr.removeAtIndex(historyArr.indexOf(self.searchBar.text!)!)
                DatabaseService.sharedInstance.deleteHistory(self.searchBar.text!)
            }
            self.historyArr.append(self.searchBar.text!)
            DatabaseService.sharedInstance.insertInHistory(self.searchBar.text!)
            //跳转到详情页
            let detailVC = DetailViewController()
            detailVC.building = currentArr[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }else if searchState == 1 && indexPath.row > 0{
            self.searchBar.text = cell.textLabel?.text?.substringFromIndex((cell.textLabel?.text!.startIndex.advancedBy(3))!)
            self.refreshSearchTableView(searchBar.text!)
        }
    }
    
    //设置删除图标响应事件
    func onDeleteHistorySearch(gesture:UITapGestureRecognizer){
        self.historyArr.removeAll()
        if DatabaseService.sharedInstance.clearHistory()
        {
            print("删除成功")
        }
        else{
            print("删除失败")
        }
        self.mainTableView.reloadData()
    }
    
    //从数据库中搜索当前关键词
    func getAllBuildings()->[BuildingData]{
        var allBuildings:[BuildingData] = [BuildingData]()
        allBuildings = Buildings
        // 模拟数据
        //        for i in 0 ... 10{
        //            let building:BuildingData = BuildingData()
        //            building.name = "Model\(i)"
        //            building.id = String(i)
        //            allBuildings.append(building)
        //        }
        return allBuildings
    }
    
    
    func filterContentForSearchText(searchText: String) {
        currentArr = self.currentArr.filter({ (buildingModel:BuildingData) -> Bool in
            let nameMatch = buildingModel.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let nameMatchInMap = buildingModel.nameinmap.rangeOfString(searchText, options: .CaseInsensitiveSearch)
            return nameMatch != nil || nameMatchInMap != nil
        })
    }
    
}
    