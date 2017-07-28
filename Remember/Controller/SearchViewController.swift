//
//  SearchViewController.swift
//  Remember
//
//  Created by Songbai Yan on 23/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController{
    fileprivate var lastTopView:UIView?
    fileprivate var lastTagButton:UIView?
    fileprivate var tagLabel:UILabel!
    
    fileprivate var tagView:UIView!
    fileprivate var tableView:UITableView!
    fileprivate let tagService = TagService()
    fileprivate let searchService = SearchService()
    fileprivate var filteredThings = [ThingModel]()
    
    var homeController:HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        initUI()
    }
    
    private func initUI(){
        let textField = InputTextField(frame: CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height:  40))
        textField.setLeftImage(with: UIImage(named: "Search")!)
        textField.setPlaceHolder(with: " 搜索你忘记的小事")
        textField.returnKeyType = .search
        textField.delegate = self
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.top.equalTo(self.view).offset(30)
            maker.right.equalTo(self.view).offset(-50)
            maker.height.equalTo(40)
        }
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.remember(), for: .normal)
        cancelButton.addTarget(self, action: #selector(SearchViewController.cancelTap(sender:)), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(textField.snp.right)
            maker.top.equalTo(textField)
            maker.right.equalTo(self.view)
            maker.height.equalTo(40)
        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.background()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(textField.snp.bottom).offset(10)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        tagView = UIView()
        self.view.addSubview(tagView)
        tagView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view)
            maker.top.equalTo(textField.snp.bottom)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        tagLabel = UILabel()
        tagLabel.text = "常用标签"
        tagLabel.textColor = UIColor.gray
        tagLabel.font = UIFont.systemFont(ofSize: 12)
        tagView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(20)
            maker.top.equalTo(textField.snp.bottom).offset(30)
        }
        lastTopView = tagLabel
        
        showTags()
        
        textField.becomeFirstResponder()
    }
    
    func cancelTap(sender:UIButton){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    private func showTags(){
        let allTags = tagService.getAllTags()
        if allTags.count > 0{
            for tag in allTags{
                updateView(for: tag.name)
            }
        }
    }
    
    private func updateView(for tag:String){
        var leftView:UIView?
        var topView:UIView! = tagLabel
        
        if lastTagButton != nil{
            let rightPoint = lastTagButton!.frame.origin.x + lastTagButton!.frame.width
            let width = self.view.frame.width - rightPoint
            let tagBounds = NSString(string: tag).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil)
            if width < 70 || width < tagBounds.width + 30{
                // 说明最右边空间不够了，该换行了
                leftView = nil
                topView = lastTagButton!
                lastTopView = lastTagButton
            }else{
                leftView = lastTagButton!
                topView = lastTopView
            }
        }
        
        lastTagButton = createNewTagButton(with: tag, last: leftView, last: topView)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    private func createNewTagButton(with tag:String, last leftView:UIView?, last topView:UIView) -> UIButton{
        let tagbutton = UIButton(type: .system)
        tagbutton.setTitle(tag, for: .normal)
        tagbutton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        tagbutton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tagbutton.layer.cornerRadius = 11
        tagbutton.backgroundColor = UIColor.remember()
        tagbutton.setTitleColor(UIColor.white, for: .normal)
        tagbutton.addTarget(self, action: #selector(SearchViewController.tagTap(sender:)), for: .touchUpInside)
        self.tagView.addSubview(tagbutton)
        tagbutton.snp.makeConstraints { (maker) in
            if leftView == nil{
                maker.left.equalTo(self.tagView).offset(20)
            }else{
                maker.left.equalTo(leftView!.snp.right).offset(10)
            }
            maker.top.equalTo(topView.snp.bottom).offset(10)
            maker.height.equalTo(22)
        }
        return tagbutton
    }
    
    func tagTap(sender:UIButton){
        
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredThings.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filteredThings[indexPath.row].content
        cell.textLabel?.textColor = UIColor.text()
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.filteredThings.count > indexPath.row
        {
            let content:NSString = self.filteredThings[indexPath.row].content! as NSString
            let size = content.boundingRect(with: CGSize(width: self.view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)], context: nil)
            return size.height + 30
        }
        else{
            return UITableViewCell().frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: false, completion: nil)
        let thing = self.filteredThings[indexPath.row]
        homeController?.openThingViewController(with: thing)
    }
}

extension SearchViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text{
            if !searchText.isEmpty{
                self.tagView.isHidden = true
                self.filteredThings = self.searchService.getFilteredThings(by: searchText)
                self.tableView.reloadData()
            }
        }
        
        return true
    }
}
