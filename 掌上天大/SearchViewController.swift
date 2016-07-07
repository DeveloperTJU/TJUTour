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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.setSearchBar()
        self.setMainTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    //设置搜索条
    func setSearchBar(){
        let labelFrame:CGRect = CGRectMake(10, 18, 50, 44)
        let backBtn:UIButton = UIButton(frame: labelFrame)
        backBtn.setTitle("返回", forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "OnBackBtnClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backBtn)
        let frame:CGRect = CGRectMake(70, 14, self.view.bounds.width-80, 48)
        self.searchBar = UISearchBar(frame: frame)
        self.searchBar.searchBarStyle = .Minimal
        self.searchBar.delegate = self
        self.searchBar.userInteractionEnabled = true
        self.searchBar.tintColor = UIColor.whiteColor()
        self.searchBar.barTintColor = UIColor.whiteColor()
        let searchFiled = searchBar.valueForKey("searchField") as! UITextField
        searchFiled.layer.cornerRadius = 3
        searchFiled.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.view.addSubview(self.searchBar)
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
        self.searchState = 0
        self.currentArr.removeAll()
        self.currentArr = self.getAllBuildings()
        self.filterContentForSearchText(string)
        self.mainTableView.reloadData()
    }
    
    
    //点击导航栏返回按钮事件
    func OnBackBtnClicked(){
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    //设置搜索结果的tableView
    func setMainTableView(){
        self.historyArr = DatabaseService.sharedInstance.loadHistory()
        let frame:CGRect = CGRectMake(0, 64, self.view.bounds.width, self.view.bounds.height)
        self.mainTableView = UITableView(frame: frame)
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        self.mainTableView.backgroundColor = UIColor(red: 244/255, green: 247/255, blue: 249/255, alpha: 1)
        self.mainTableView.backgroundColor  = UIColor.clearColor()
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
        if searchState == 1{
            if indexPath.row == 0{
                let textWidth:CGFloat = 100.0//文本标签宽度
                let imageWidth:CGFloat = 20.0//iamgeView的宽度
                let textX:CGFloat = (self.view.frame.width-textWidth-imageWidth)/2//文本标签x值
                //添加文本
                let textframe:CGRect = CGRectMake(textX, 0, textWidth, cell.frame.height)
                let textLabel:UILabel = UILabel(frame: textframe)
                textLabel.text = "历史搜索"
                textLabel.textColor = UIColor.whiteColor()
                textLabel.textAlignment = .Center
                cell.addSubview(textLabel)
                
                //添加删除图标
                let imageFrame:CGRect = CGRectMake(textWidth+textX, (cell.frame.height-imageWidth)/2, imageWidth, imageWidth)
                let imageView:UIImageView = UIImageView(frame: imageFrame)
                let image = UIImage(named: "删除")
                
                let colorImage = image?.tint(UIColor.whiteColor(), blendMode: .DestinationIn)
                imageView.image = colorImage
                let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onDeleteHistorySearch:")
                imageView.userInteractionEnabled = true
                imageView.addGestureRecognizer(gesture)
                cell.addSubview(imageView)
                
                //添加分割线
                let textSize:CGSize = textLabel.text!.sizeWithAttributes(["sizeWithFont":textLabel.font,"forWidth":textLabel.bounds.size.width])
                let distance = (textWidth - textSize.width)/2-10//文本开始位置，与标签开始位置的间距
                
                let leftFrame:CGRect = CGRectMake(10, cell.frame.height/2, textX+distance-10, 1)
                let leftView:UIView = UIView(frame: leftFrame)
                leftView.backgroundColor = UIColor.whiteColor()
                cell.addSubview(leftView)
                
                let centerFrame:CGRect = CGRectMake(textX+textWidth-distance, cell.frame.height/2, distance, 1)
                let centerView:UIView = UIView(frame: centerFrame)
                centerView.backgroundColor = UIColor.whiteColor()
                cell.addSubview(centerView)
                
                let rightFrame:CGRect = CGRectMake(textX+textWidth+imageWidth, cell.frame.height/2, self.view.frame.width-(textX+textWidth+imageWidth)-10, 1)
                let rightView:UIView = UIView(frame: rightFrame)
                rightView.backgroundColor = UIColor.whiteColor()
                cell.addSubview(rightView)
            }else{
                cell.textLabel?.drawTextInRect(CGRectMake(100, 0, self.mainTableView.bounds.width-50, 0))
                cell.textLabel?.text = "   " + historyArr[self.historyArr.count - indexPath.row]
                cell.textLabel?.textColor = UIColor.whiteColor()
            }
            return cell
        }
        else if searchState == 0{
            //搜索状态，显示当前搜索
            cell.textLabel!.text = self.currentArr[indexPath.row].name
            cell.textLabel!.textColor = UIColor.whiteColor()
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
            let index = BuildingIndexDict[currentArr[indexPath.row].id]
            detailVC.buildingIndex = index
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
    
    //搜索数据
    func filterContentForSearchText(searchText: String) {
        currentArr = self.currentArr.filter({ (buildingModel:BuildingData) -> Bool in
            let nameMatch = buildingModel.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let nameMatchInMap = buildingModel.nameinmap.rangeOfString(searchText, options: .CaseInsensitiveSearch)
            return nameMatch != nil || nameMatchInMap != nil
        })
    }
    
}
    