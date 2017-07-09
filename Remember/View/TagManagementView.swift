//
//  TagManagementView.swift
//  Remember
//
//  Created by Songbai Yan on 08/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class TagManagementView: UIView {
    private var lastTagButton:UIView?
    private var lastTopView:UIView?
    private var currentThing:ThingModel?
    
    var thing:ThingModel?
    var addTagTextField:UITextField!
    var addTagButton:UIButton!
    let tagService = TagService()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTagButton = UIButton(type: .system)
        addTagButton.setTitle("+添加标签", for: .normal)
        addTagButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        addTagButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addTagButton.layer.cornerRadius = 10
        addTagButton.backgroundColor = UIColor.remember()
        addTagButton.setTitleColor(UIColor.white, for: .normal)
        addTagButton.addTarget(self, action: #selector(TagManagementView.addTagTap(sender:)), for: .touchUpInside)
        self.addSubview(addTagButton)
        addTagButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
        }
        
        addTagTextField = UITextField()
        addTagTextField.isHidden = true
        addTagTextField.delegate = self
        addTagTextField.font = UIFont.systemFont(ofSize: 12)
        addTagTextField.returnKeyType = .done
        addTagTextField.placeholder = "添加标签"
        self.addSubview(addTagTextField)
        addTagTextField.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.left.equalTo(self)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
        }
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 100, y: 100, width: 70, height: 20)
        button.setTitle("aaaa", for: .normal)
        button.addTarget(self, action: #selector(TagManagementView.click(sender:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    func click(sender:UIButton){
        print("agagag")
    }
    
    func addTagTap(sender:UIButton){
        addTagTextField.isHidden = false
        addTagTextField.becomeFirstResponder()
        addTagButton.isHidden = true
        
        if let currentThing = self.thing{
            self.startEdit(with:currentThing)
        }
    }
    
    func startEdit(with thing:ThingModel){
        self.currentThing = thing
        
        showUnselectedExistingTags()
    }
    
    private func showUnselectedExistingTags(){
        if let thing = self.currentThing{
            let tags = tagService.getUnselectedTags(by: thing)
            print(tags)
        }
    }
    
    func updateView(with tag:String){
        updateView(for: tag)
    }
    
    func updateView(from tags:[TagModel]){
        for tag in tags{
            updateView(for: tag.name)
        }
    }
    
    private func updateView(for tag:String){
        var leftView:UIView? = addTagButton
        var topView:UIView?
        
        lastTagButton = self.subviews.last
        if lastTagButton != nil{
            let rightPoint = lastTagButton!.frame.origin.x + lastTagButton!.frame.width
            let width = self.frame.width - rightPoint
            let tagBounds = NSString(string: tag).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil)
            if width < 70 || width < tagBounds.width + 20{
                // 说明最右边空间不够了，该换行了
                leftView = nil
                topView = lastTagButton!
                lastTopView = lastTagButton
            }else{
                leftView = lastTagButton!
                topView = lastTopView
            }
        }
        
        createNewTagButton(with: tag, last: leftView, last: topView)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func createNewTagButton(with tag:String, last leftView:UIView?, last topView:UIView?){
        let tagbutton = UIButton(type: .system)
        tagbutton.setTitle(tag, for: .normal)
        tagbutton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        tagbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tagbutton.layer.cornerRadius = 10
        tagbutton.backgroundColor = UIColor.remember()
        tagbutton.setTitleColor(UIColor.white, for: .normal)
        tagbutton.addTarget(self, action: #selector(TagManagementView.addTagTap(sender:)), for: .touchUpInside)
        self.addSubview(tagbutton)
        tagbutton.snp.makeConstraints { (maker) in
            if leftView == nil{
                maker.left.equalTo(self)
            }else{
                maker.left.equalTo(leftView!.snp.right).offset(10)
            }
            if topView == nil{
                maker.top.equalTo(self)
            }else{
                maker.top.equalTo(topView!.snp.bottom).offset(10)
            }
            maker.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TagManagementView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let tag = textField.text{
            if !tagService.exists(tag){
                self.updateView(with: tag)
                textField.text = ""
                
                saveTag(tag)
            }
        }
        
        addTagTextField.isHidden = true
        addTagButton.isHidden = false
        
        return true
    }
    
    private func saveTag(_ tag:String){
        let tagModel = TagModel(name: tag)
        let thingTagModel = ThingTagModel(thingId: self.thing!.id, tagId: tagModel.id)
        
        tagService.save(tagModel)
        tagService.saveThingTag(thingTagModel)
    }
}
