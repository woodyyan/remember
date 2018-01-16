//
//  EditThingViewController.swift
//  Remember
//
//  Created by Songbai Yan on 28/02/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SCLAlertView

class EditThingViewController: UIViewController {
    fileprivate var service = ThingService()
    fileprivate var tagService = TagService()
    
    var isEditTag = false
    var thing:ThingModel?
    var delegate:EditThingDelegate?
    var editView:UITextView!
    var scrollView:UIScrollView!
    var tagManagementView:TagManagementView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "编辑"
        self.view.backgroundColor = UIColor.background()
        self.navigationController?.navigationBar.tintColor = UIColor.remember()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.remember()];
        
        let shareButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(EditThingViewController.shareTap(sender:)))
        shareButtonItem.imageInsets = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        let deleteButtonItem = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(EditThingViewController.deleteTap(sender:)))
        deleteButtonItem.imageInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: -12)
        self.navigationItem.rightBarButtonItems = [shareButtonItem, deleteButtonItem]
        
        initUI()
    }
    
    @objc func shareTap(sender:UIBarButtonItem){
        if let content = thing?.content{
            let activityController = HomeService.getActivityViewController(content: content)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    @objc func deleteTap(sender:UIBarButtonItem){
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("确认删除", backgroundColor: UIColor(red: 251/255, green: 103/255, blue: 83/255, alpha: 1), textColor: UIColor.white, showTimeout: nil, action: {
            if let currentThing = self.thing{
                self.service.delete(currentThing)
                self.delegate?.editThing(isDeleted: true, thing: currentThing)
                self.navigationController?.popViewController(animated: true)
            }
        })
        alertView.addButton("取消", backgroundColor: UIColor(red: 254/255, green: 208/255, blue: 52/255, alpha: 1), textColor: UIColor.white, showTimeout: nil, action: {
        })
        
        alertView.showWarning("确定要删除吗？", subTitle: "删除后就找不回来啦。")
    }
    
    private func initUI(){
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        let createdDateLabel = UILabel()
        createdDateLabel.text = getCreatedDateText()
        createdDateLabel.textColor = UIColor.gray
        createdDateLabel.font = UIFont.systemFont(ofSize: 10)
        scrollView.addSubview(createdDateLabel)
        createdDateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView).offset(20)
            maker.left.equalTo(scrollView).offset(15)
        }
        
        editView = UITextView()
        editView.font = UIFont.systemFont(ofSize: 18)
        editView.layer.cornerRadius = 8
        editView.backgroundColor = UIColor.white
        editView.textColor = UIColor.text()
        editView.text = thing?.content
        editView.returnKeyType = .done
        editView.delegate = self
        scrollView.addSubview(editView)
        editView.snp.makeConstraints { (maker) in
            maker.top.equalTo(createdDateLabel.snp.bottom).offset(10)
            maker.left.equalTo(scrollView).offset(10)
            maker.height.greaterThanOrEqualTo(100)
            maker.width.equalTo(scrollView.frame.width - 20)
        }
        
        tagManagementView = TagManagementView(frame: CGRect(x: 0, y: 200, width: 375, height: 300))
        tagManagementView.delegate = self
        tagManagementView.thing = self.thing
        scrollView.addSubview(tagManagementView)
        tagManagementView.snp.makeConstraints { (maker) in
            maker.top.equalTo(editView.snp.bottom).offset(10)
            maker.width.equalTo(scrollView)
            maker.left.equalTo(scrollView)
            maker.right.equalTo(scrollView)
            maker.height.equalTo(600)
        }
        
        showAddedTags()
        
        if isEditTag{
            tagManagementView.startEdit()
        }
    }
    
    private func showAddedTags(){
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        if let currentThing = self.thing{
            self.tagManagementView.updateView(by: currentThing)
        }
    }
    
    private func getCreatedDateText() -> String{
        var dateText = ""
        if let date = thing?.createdAt{
            dateText = service.getCreatedDateText(from: date as Date)
        }
        return dateText
    }
}

extension EditThingViewController: TagManagementDelegate{
    func tagManagement(view: TagManagementView, tag: String) {
        if let currentThing = thing{
            delegate?.editThing(isDeleted: false, thing: currentThing)
        }
    }
}

extension EditThingViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            if let tempThing = thing{
                tempThing.content = editView.text
                self.service.edit(tempThing)
                delegate?.editThing(isDeleted: false, thing: tempThing)
            }
            return false
        }
        return true
    }
}

protocol EditThingDelegate {
    func editThing(isDeleted:Bool, thing:ThingModel)
}
