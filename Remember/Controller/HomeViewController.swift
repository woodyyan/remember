//
//  ViewController.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        inputThingView = InputThingView(frame: CGRect(x: 0, y: self.view.frame.height - 46, width: self.view.frame.width, height: 46))
        inputThingView.delegate = self
        self.view.addSubview(inputThingView)
    }
    
    private func initSearchBar(){
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "搜索你忘记的小事"
        tableView.tableHeaderView = searchBar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.showSearchController))
        tapGesture.numberOfTapsRequired = 1
        searchBar.addGestureRecognizer(tapGesture)
    }
    
    func showSearchController(){
        print("aaa")
    }
    
    private func initTableView(){
        var statusHeight = UIApplication.shared.statusBarFrame.height
        if let navBarHeight = self.navigationController?.navigationBar.frame.height{
            statusHeight += navBarHeight
        }
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 46), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.background()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(tableView)
    }
    
    func keyboardWillHide(_ notice:Notification){
        inputThingView.frame = CGRect(x: 0, y: self.view.frame.height - 46, width: self.view.frame.width, height: 46)
        self.dismiss(animated: false, completion: nil)
    }
    
    func keyboardWillShow(_ notice:Notification){
        let userInfo:NSDictionary = (notice as NSNotification).userInfo! as NSDictionary
        let endFrameValue: NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let endFrame = endFrameValue.cgRectValue
        inputThingView.frame = CGRect(x: 0, y: self.view.bounds.height - 46 - endFrame.height, width: self.view.bounds.width, height: 46)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = things[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content:NSString = things[indexPath.row].content as NSString
        let size = content.boundingRect(with: CGSize(width: self.view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)], context: nil)
        return size.height + 20
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

extension HomeViewController : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        openSearchController()
        return false
    }
    
    private func openSearchController(){
        let searchResultController = SearchResultTableViewController()
        searchResultController.things = self.things
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "搜索你忘记的小事"
        searchController.searchResultsUpdater = searchResultController
//        searchController.searchBar.barTintColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = true
        self.present(searchController, animated: true){
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}

extension HomeViewController : ThingInputDelegate{
    func input(inputView: InputThingView, thing: ThingEntity) {
        self.things.append(thing)
        tableView.reloadData()
    }
}

