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
    fileprivate var searchController:UISearchController!
    
    fileprivate var things = [ThingEntity]()
    fileprivate var filteredThings = [ThingEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
    }
    
    private func initUI(){
        self.title = "丁丁记事"
        self.view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white];
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 156/255, blue: 43/255, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关于", style: .plain, target: self, action: #selector(HomeViewController.pushToAboutPage(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
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
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "搜索你忘记的小事"
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.barTintColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    private func initTableView(){
        var statusHeight = UIApplication.shared.statusBarFrame.height
        if let navBarHeight = self.navigationController?.navigationBar.frame.height{
            statusHeight += navBarHeight
        }
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 46), style: UITableViewStyle.plain)
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
        let inputView = self.view.viewWithTag(111)
        inputView?.frame = CGRect(x: 0, y: self.view.bounds.height - 46 - endFrame.height, width: self.view.bounds.width, height: 46)
    }
    
    func pushToAboutPage(_ sender:UIBarButtonItem){
    }
    
    fileprivate func getThings() -> [ThingEntity]{
        return self.searchController != nil && self.searchController.isActive ? self.filteredThings : self.things
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getThings().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = getThings()[indexPath.row].content
        return cell
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

extension HomeViewController : UISearchResultsUpdating, UISearchControllerDelegate{
    // Uupdate searching results
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text{
            filterResultsForSearchText(searchText)
        }
        self.tableView.reloadData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        inputThingView.isHidden = true
    }
    
    private func filterResultsForSearchText(_ searchText: String){
        if searchText.isEmpty{
            self.filteredThings = self.things
        }else{
            self.filteredThings = self.things.filter({ (thing) -> Bool in
                return thing.content.contains(searchText)
            })
        }
    }
}

extension HomeViewController : ThingInputDelegate{
    func input(inputView: InputThingView, thing: ThingEntity) {
        self.things.append(thing)
        tableView.reloadData()
    }
}

