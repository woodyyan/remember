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
    
    var thing:ThingModel?
    var delegate:EditThingDelegate?
    var editView:UITextView!
    var addTagTextField:UITextField!
    var addTagButton:UIButton!
    var scrollView:UIScrollView!
    var lastTagButton:UIButton?
    var lastTopView:UIView?
    
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
        lastTopView = editView
        
        initTags(scrollView)
    }
    
    private func initTags(_ scrollView:UIScrollView){
        addTagButton = UIButton(type: .system)
        addTagButton.setTitle("+添加标签", for: .normal)
        addTagButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        addTagButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addTagButton.layer.cornerRadius = 10
        addTagButton.backgroundColor = UIColor.remember()
        addTagButton.setTitleColor(UIColor.white, for: .normal)
        addTagButton.addTarget(self, action: #selector(EditThingViewController.addTagTap(sender:)), for: .touchUpInside)
        scrollView.addSubview(addTagButton)
        addTagButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(editView.snp.bottom).offset(10)
            maker.left.equalTo(editView)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
        }
        
        addTagTextField = UITextField()
        addTagTextField.isHidden = true
        addTagTextField.delegate = self
        addTagTextField.font = UIFont.systemFont(ofSize: 12)
        addTagTextField.returnKeyType = .done
        addTagTextField.placeholder = "添加标签"
        scrollView.addSubview(addTagTextField)
        addTagTextField.snp.makeConstraints { (maker) in
            maker.top.equalTo(editView.snp.bottom).offset(10)
            maker.left.equalTo(editView)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
        }
        
        showSelectedTags()
    }
    
    func addTagTap(sender:UIButton){
        addTagTextField.isHidden = false
        addTagTextField.becomeFirstResponder()
        addTagButton.isHidden = true
        
        showUnselectedExistingTags()
    }
    
    private func showSelectedTags(){
//        if let currentThing = self.thing{
//            let tags = service.getSelectedTags(by: currentThing)
//            //TODO
//        }
    }
    
    private func showUnselectedExistingTags(){
//        if let currentThing = self.thing{
//            let tags = service.getUnselectedTags(by: currentThing)
//            //TODO
//        }
    }
    
    private func getCreatedDateText() -> String{
        var dateText = ""
        if let date = thing?.createdAt{
            dateText = service.getCreatedDateText(from: date as Date)
        }
        return dateText
    }
}

extension EditThingViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let tag = textField.text{
            if !service.exists(tag){
                var leftView:UIView = addTagButton
                var topView:UIView = editView
                if lastTagButton != nil{
                    let rightPoint = lastTagButton!.frame.origin.x + lastTagButton!.frame.width
                    let width = scrollView.frame.width - rightPoint
                    let tagBounds = NSString(string: tag).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil)
                    if width < 70 || width < tagBounds.width + 20{
                        // 说明最右边空间不够了，该换行了
                        leftView = scrollView
                        topView = lastTagButton!
                        lastTopView = lastTagButton
                    }else{
                        leftView = lastTagButton!
                        topView = lastTopView!
                    }
                }
                
                lastTagButton = createNewTagButton(with: tag, last: leftView, last: topView)
                textField.text = ""
                
                saveTag(tag)
            }
        }
        
        addTagTextField.isHidden = true
        addTagButton.isHidden = false
        
        return true
    }
    
    private func saveTag(_ tag:String){
        let tagEntity = TagEntity()
        tagEntity.name = tag
        //TODO tagId tagIndex
        
        
//        let thingTagEntity = ThingTagEntity()
//        thingTagEntity.tag = tagEntity
//        thingTagEntity.tagId = tagEntity.id
//        thingTagEntity.thing = self.thing
//        thingTagEntity.thingId = self.thing?.id
//        
//        service.saveThingTag(for: tagEntity, with: thingTagEntity)
    }
    
    private func createNewTagButton(with tag:String, last leftView:UIView, last topView:UIView) -> UIButton{
        let tagbutton = UIButton(type: .system)
        tagbutton.setTitle(tag, for: .normal)
        tagbutton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        tagbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tagbutton.layer.cornerRadius = 10
        tagbutton.backgroundColor = UIColor.white
        tagbutton.setTitleColor(UIColor.remember(), for: .normal)
        tagbutton.addTarget(self, action: #selector(EditThingViewController.addTagTap(sender:)), for: .touchUpInside)
        scrollView.addSubview(tagbutton)
        tagbutton.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftView.snp.right).offset(10)
            maker.top.equalTo(topView.snp.bottom).offset(10)
            maker.height.equalTo(20)
        }
        return tagbutton
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
