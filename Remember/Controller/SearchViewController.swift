//
//  SearchViewController.swift
//  Remember
//
//  Created by Songbai Yan on 23/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    private var lastTopView: UIView?
    private var lastTagButton: UIView?
    private var tagLabel: UILabel!
    
    private var tagView: UIView!
    private var textField: InputTextField!
    private var tableView: UITableView!
    private let tagService = TagService()
    private let searchService = SearchService()
    private var filteredThings = [ThingModel]()
    
    var homeController: HomeViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ALBBMANPageHitHelper.getInstance().pageAppear(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ALBBMANPageHitHelper.getInstance().pageDisAppear(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        initUI()
        
        let selector = #selector(SearchViewController.keyboardWillShow(_:))
        NotificationCenter.addObserver(self, selector, NSNotification.Name.UIKeyboardWillShow)
    }
    
    @objc func keyboardWillShow(_ notice: Notification) {
        let userInfo: NSDictionary = (notice as NSNotification).userInfo! as NSDictionary
        let endFrameValue: NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let endFrame = endFrameValue.cgRectValue
        tableView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view).offset(-endFrame.height)
        }
    }
    
    private func initUI() {
        initTextField()
        
        let cancelButton = getCancelButton()
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(textField.snp.right)
            maker.top.equalTo(textField)
            maker.right.equalTo(self.view)
            maker.height.equalTo(40)
        }
        
        let rect = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(textField.snp.bottom).offset(10)
            maker.left.right.bottom.equalTo(self.view)
        }
        
        tagView = UIView()
        self.view.addSubview(tagView)
        tagView.snp.makeConstraints { (maker) in
            maker.top.equalTo(textField.snp.bottom)
            maker.left.right.bottom.equalTo(self.view)
        }
        
        tagLabel = UILabel()
        tagLabel.text = NSLocalizedString("commonTags", comment: "常用标签")
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
    
    private func initTextField() {
        textField = InputTextField(frame: CGRect(x: 10, y: 10, width: self.width - 20, height: 40))
        textField.setLeftImage(with: UIImage(named: "Search")!)
        textField.setPlaceHolder(with: NSLocalizedString("searchPlaceHolder", comment: ""))
        textField.returnKeyType = .search
        textField.delegate = self
        textField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(sender:)), for: .editingChanged)
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.top.equalTo(self.view).offset(30)
            maker.right.equalTo(self.view).offset(-50)
            maker.height.equalTo(40)
        }
    }
    
    private func getCancelButton() -> UIButton {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        cancelButton.setTitleColor(UIColor.remember, for: .normal)
        cancelButton.addTarget(self, action: #selector(SearchViewController.cancelTap(sender:)), for: .touchUpInside)
        return cancelButton
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                showAllTags()
            } else {
                search(text: text)
            }
        }
    }
    
    private func search(text: String) {
        self.tagView.isHidden = true
        if text.hasPrefix("#") {
            let trimText = text.trimmingCharacters(in: CharacterSet.init(charactersIn: "#"))
            self.filteredThings = searchService.getThings(byTag: trimText)
        } else {
            self.filteredThings = self.searchService.getThings(byText: text)
        }
        self.tableView.reloadData()
    }
    
    func showAllTags() {
        self.filteredThings.removeAll()
        self.tableView.reloadData()
        self.tagView.isHidden = false
    }
    
    @objc func cancelTap(sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    private func showTags() {
        let allTags = tagService.getAllTags()
        if !allTags.isEmpty {
            for tag in allTags {
                updateView(for: tag.name)
            }
        } else {
            self.tagView.isHidden = true
        }
    }
    
    private func updateView(for tag: String) {
        var leftView: UIView?
        var topView: UIView! = tagLabel
        
        if lastTagButton != nil {
            let rightPoint = lastTagButton!.frame.origin.x + lastTagButton!.width
            let width = self.width - rightPoint
            let expectSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20.0)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let tagBounds = NSString(string: tag).boundingRect(with: expectSize, options: option, attributes: attributes, context: nil)
            if width < 70 || width < tagBounds.width + 30 {
                // 说明最右边空间不够了，该换行了
                leftView = nil
                topView = lastTagButton!
                lastTopView = lastTagButton
            } else {
                leftView = lastTagButton!
                topView = lastTopView
            }
        }
        
        lastTagButton = createNewTagButton(with: tag, last: leftView, last: topView)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    private func createNewTagButton(with tag: String, last leftView: UIView?, last topView: UIView) -> UIButton {
        let tagbutton = UIButton(type: .system)
        tagbutton.setTitle(tag, for: .normal)
        tagbutton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        tagbutton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tagbutton.layer.cornerRadius = 11
        tagbutton.backgroundColor = UIColor.remember
        tagbutton.setTitleColor(UIColor.white, for: .normal)
        tagbutton.addTarget(self, action: #selector(SearchViewController.tagTap(sender:)), for: .touchUpInside)
        self.tagView.addSubview(tagbutton)
        tagbutton.snp.makeConstraints { (maker) in
            if leftView == nil {
                maker.left.equalTo(self.tagView).offset(20)
            } else {
                maker.left.equalTo(leftView!.snp.right).offset(10)
            }
            maker.top.equalTo(topView.snp.bottom).offset(10)
            maker.height.equalTo(22)
        }
        return tagbutton
    }
    
    @objc func tagTap(sender: UIButton) {
        if let tag = sender.titleLabel?.text {
            self.tagView.isHidden = true
            self.filteredThings = searchService.getThings(byTag: tag)
            self.tableView.reloadData()
            self.textField.text = "#\(tag)"
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredThings.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filteredThings[indexPath.row].content
        cell.textLabel?.textColor = UIColor.text
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.filteredThings.count > indexPath.row {
            let content: NSString = self.filteredThings[indexPath.row].content! as NSString
            let expectSize = CGSize(width: self.width - 30, height: CGFloat.greatestFiniteMagnitude)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let size = content.boundingRect(with: expectSize, options: option, attributes: attributes, context: nil)
            return size.height + 30
        } else {
            return UITableViewCell().height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
        let thing = self.filteredThings[indexPath.row]
        homeController?.openThingViewController(with: thing)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            if !searchText.isEmpty {
                search(text: searchText)
            }
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        showAllTags()
        return true
    }
}
