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
    
    //数据库部分
    var dataService:DatabaseService = DatabaseService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.setSearchBar()
        
        self.setMainTableView()
    }
    
    //设置搜索条
    func setSearchBar(){
        let leftBtn:UIBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "OnBackBtnClicked")
        self.navigationItem.leftBarButtonItem = leftBtn
        let frame:CGRect = CGRectMake(50, 0, self.view.bounds.width-50, 0)
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
        for i in 0 ..< buildings.count{
            let name = buildings[i].name
            if name.containsString(string){
                let building:BuildingData = BuildingData()
                building.name = buildings[i].name
                building.id = buildings[i].id
                self.currentArr.append(building)
            }
        }
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
        self.historyArr = dataService.loadHistory()
        let frame:CGRect = CGRectMake(10, 10, self.view.bounds.width-20, self.view.bounds.height)
        self.mainTableView = UITableView(frame: frame)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = UIColor.clearColor()
        
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
        tableView.separatorStyle = .None
        if searchState == 1{
            if indexPath.row == 0{
                cell.textLabel?.text = "历史搜索"
                let imageFrame:CGRect = CGRectMake(self.mainTableView.bounds.width-80, 0, 50, cell.bounds.size.height)
                //let deleteImage:UIImageView = UIImageView(frame: imageFrame)
                let deleteBtn:UIButton = UIButton(frame: imageFrame)
                deleteBtn.setTitle("删除", forState: UIControlState.Normal)
                deleteBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                deleteBtn.addTarget(self, action: "onDeleteHistorySearch", forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(deleteBtn)
            }else{
                cell.textLabel?.drawTextInRect(CGRectMake(100, 0, self.mainTableView.bounds.width-50, 0))
                cell.textLabel?.text = "   " + historyArr[self.historyArr.count - indexPath.row]
                cell.accessoryType = .DisclosureIndicator
            }
            return cell
        }
        else if searchState == 0{
            //搜索状态，显示当前搜索
            cell.textLabel!.text = self.currentArr[indexPath.row].name
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
            }
            self.historyArr.append(self.searchBar.text!)
            //            let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            //            let set:NSArray = NSArray(array: self.historyArr)
            //            userDefault.setObject(set, forKey: "history")
            dataService.insertInHistory(self.searchBar.text!)
            
            let detailVC = DetailViewController()
            
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }else if searchState == 1 && indexPath.row > 0{
            self.searchBar.text = cell.textLabel?.text?.substringFromIndex((cell.textLabel?.text!.startIndex.advancedBy(3))!)
            self.refreshSearchTableView(searchBar.text!)
        }
    }
    
    //设置删除图标响应事件
    func onDeleteHistorySearch(){
        self.historyArr.removeAll()
        //        let userDefault = NSUserDefaults.standardUserDefaults()
        //        let array:NSArray = NSArray(array: [])
        //        userDefault.setObject(array, forKey: "history")
        
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
        
        //因返回数据库为空，此处模拟数据
        for i in 0 ... 10{
            let building:BuildingData = BuildingData()
            building.name = "Model\(i)"
            building.id = String(i)
            allBuildings.append(building)
        }
        return allBuildings
    }
}
    