//
//  EditThingViewController.swift
//  Remember
//
//  Created by Songbai Yan on 28/02/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class EditThingViewController: UIViewController {
    fileprivate var service = ThingService()
    fileprivate var tagService = TagService()
    
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.remember()];
        
        let shareButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(EditThingViewController.shareTap(sender:)))
        let deleteButtonItem = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(EditThingViewController.deleteTap(sender:)))
        self.navigationItem.rightBarButtonItems = [shareButtonItem, deleteButtonItem]
        
        initUI()
    }
    
    func shareTap(sender:UIBarButtonItem){
        if let content = thing?.content{
            let activityController = HomeService.getActivityViewController(content: content)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    func deleteTap(sender:UIBarButtonItem){
        let alertController = UIAlertController(title: "提示", message: "确认要删除吗？", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        })
        alertController.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
            //TODO
        })
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func doneEditClick(sender:UIBarButtonItem){
        if let tempThing = thing{
            tempThing.content = editView.text
            self.service.edit(tempThing)
            delegate?.editThing(edit: true, thing: tempThing)
        }
        _ = self.navigationController?.popViewController(animated: true)
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
    }
    
    private func showAddedTags(){
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        if let currentThing = self.thing{
            let tags = tagService.getSelectedTags(by: currentThing)
            self.tagManagementView.updateView(from: tags)
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

extension EditThingViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

protocol EditThingDelegate {
    func editThing(edit complete:Bool, thing:ThingModel)
}
