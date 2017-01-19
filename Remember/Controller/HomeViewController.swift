//
//  ViewController.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let inputViewHeight:CGFloat = 60
    
    fileprivate var viewModel = HomeViewModel()
    fileprivate var inputThingView:InputThingView!
    fileprivate var tableView:UITableView!
    
    fileprivate var things = [ThingEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
    }
    
    private func initUI(){
        self.title = "丁丁记事"
        self.view.backgroundColor = UIColor.background()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.remember()];
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关于", style: .plain, target: self, action: #selector(HomeViewController.pushToAboutPage(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.remember()
        
        initTableView()
        initInputView()
        initSearchBar()
        setKeyboardNotification()
        
        initData()
    }
    
    private func initData(){
        things = viewModel.things
    }
    
    private func setKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func initInputView(){
        inputThingView = InputThingView(frame: CGRect(x: 0, y: self.view.frame.height - inputViewHeight, width: self.view.frame.width, height: inputViewHeight))
        inputThingView.delegate = self
        self.view.addSubview(inputThingView)
    }
    
    private func initSearchBar(){
        let searchButton = UIButton(type: UIButtonType.system)
        searchButton.setTitle("搜索你忘记的小事", for: UIControlState.normal)
        searchButton.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 40)
        searchButton.layer.borderColor = UIColor.inputGray().cgColor
        searchButton.layer.borderWidth = 1
        searchButton.layer.cornerRadius = 20
        searchButton.backgroundColor = UIColor.inputGray()
        searchButton.setTitleColor(UIColor.remember(), for: UIControlState.normal)
        searchButton.addTarget(self, action: #selector(HomeViewController.searchClick(_:)), for: UIControlEvents.touchUpInside)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        headerView.addSubview(searchButton)
        
        tableView.tableHeaderView = headerView
    }
    
    func searchClick(_ sender:UIButton) {
        let searchResultController = SearchResultTableViewController()
        searchResultController.things = self.things
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "搜索你忘记的小事"
        searchController.searchResultsUpdater = searchResultController
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        self.present(searchController, animated: true){
        }
    }
    
    private func initTableView(){
        var statusHeight = UIApplication.shared.statusBarFrame.height
        if let navBarHeight = self.navigationController?.navigationBar.frame.height{
            statusHeight += navBarHeight
        }
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - inputViewHeight), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.background()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ThingTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(tableView)
    }
    
    func keyboardWillHide(_ notice:Notification){
        inputThingView.frame = CGRect(x: 0, y: self.view.frame.height - inputViewHeight, width: self.view.frame.width, height: inputViewHeight)
        self.dismiss(animated: false, completion: nil)
    }
    
    func keyboardWillShow(_ notice:Notification){
        let userInfo:NSDictionary = (notice as NSNotification).userInfo! as NSDictionary
        let endFrameValue: NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let endFrame = endFrameValue.cgRectValue
        inputThingView.frame = CGRect(x: 0, y: self.view.bounds.height - inputViewHeight - endFrame.height, width: self.view.bounds.width, height: inputViewHeight)
    }
    
    func pushToAboutPage(_ sender:UIBarButtonItem){
        let aboutController = AboutViewController(style: .grouped)
        self.navigationController?.pushViewController(aboutController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.things.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThingTableViewCell
        cell.textLabel?.text = things[indexPath.row].content
        cell.setBackground(style: getCellBackgroundStyle(indexPath.row))
        return cell
    }
    
    private func getCellBackgroundStyle(_ index:Int) -> ThingCellBackgroundStyle{
        var style = ThingCellBackgroundStyle.normal
        let lastNumber = things.count - 1
        switch index {
        case 0:
            style = ThingCellBackgroundStyle.first
        case lastNumber:
            style = ThingCellBackgroundStyle.last
        default:
            style = ThingCellBackgroundStyle.normal
        }
        return style
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content:NSString = things[indexPath.row].content as NSString
        let size = content.boundingRect(with: CGSize(width: self.view.frame.width - 140, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)], context: nil)
        return size.height + 30
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            let alertController = UIAlertController(title: "提示", message: "确认要删除吗？", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                tableView.setEditing(false, animated: true)
            })
            alertController.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
                let index=(indexPath as NSIndexPath).row as Int
                let thing = self.things[index]
                self.things.remove(at: index)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                self.viewModel.deleteThing(thing)
            })
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController : UISearchControllerDelegate{
    func didDismissSearchController(_ searchController: UISearchController) {
        print("ag")
    }
}

extension HomeViewController : ThingInputDelegate{
    func input(inputView: InputThingView, thing: ThingEntity) {
        self.things.append(thing)
        tableView.reloadData()
    }
}

