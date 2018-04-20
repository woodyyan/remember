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
    private var lastTagButton: UIView?
    private var lastTopView: UIView?
    private var lastExistingTagButton: UIView?
    private var lastExistingTopView: UIView?
    private var tagScrollView: UIScrollView!
    private var selectedTags = [TagModel]()
    private var unselectedTags = [TagModel]()
    private var tagButtons = [UIButton]()
    private var isEditing = false
    
    var thing: ThingModel?
    var addTagTextField: UITextField!
    var addTagButton: UIButton!
    weak var delegate: TagManagementDelegate?
    
    let tagService = TagService()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTagButton = UIButton(type: .system)
        addTagButton.setTitle(NSLocalizedString("addTag", comment: ""), for: .normal)
        addTagButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        addTagButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addTagButton.layer.cornerRadius = 10
        addTagButton.backgroundColor = UIColor.remember
        addTagButton.setTitleColor(UIColor.white, for: .normal)
        addTagButton.addTarget(self, action: #selector(TagManagementView.addTagTap(sender:)), for: .touchUpInside)
        self.addSubview(addTagButton)
        addTagButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.left.equalTo(self).offset(10)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
        }
        
        addTagTextField = UITextField()
        addTagTextField.isHidden = true
        addTagTextField.delegate = self
        addTagTextField.font = UIFont.systemFont(ofSize: 12)
        addTagTextField.returnKeyType = .done
        addTagTextField.placeholder = NSLocalizedString("addTagLabel", comment: "")
        self.addSubview(addTagTextField)
        addTagTextField.snp.makeConstraints { (maker) in
            maker.top.equalTo(self)
            maker.left.equalTo(self).offset(10)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
        }
        
        tagScrollView = UIScrollView(frame: CGRect(x: 0, y: 100, width: self.frame.width, height: 44))
        tagScrollView!.isHidden = true
        tagScrollView!.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        tagScrollView!.alwaysBounceHorizontal = true
        self.addSubview(tagScrollView!)
        
        let showSelector = #selector(TagManagementView.keyboardWillShow(_:))
        NotificationCenter.default.addObserver(self, selector: showSelector, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        let hideSelector = #selector(TagManagementView.keyboardWillHide(_:))
        NotificationCenter.default.addObserver(self, selector: hideSelector, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func addTagTap(sender: UIButton) {
        self.startEdit()
    }
    
    func startEdit() {
        isEditing = true
        addTagTextField.isHidden = false
        addTagTextField.becomeFirstResponder()
        addTagButton.isHidden = true
        changeTagButton(true)
        showUnselectedExistingTags()
    }
    
    func endEdit() {
        isEditing = false
        changeTagButton(false)
    }
    
    private func changeTagButton(_ isEditing: Bool) {
        tagButtons.forEach { (button) in
            if isEditing {
                button.setImage(UIImage(named: "cross"), for: .normal)
                button.tintColor = UIColor.white
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }
    
    private func showUnselectedExistingTags() {
        if let currentThing = self.thing {
            for view in self.tagScrollView!.subviews {
                view.removeFromSuperview()
            }
            
            var lastButton: UIButton?
            var width: CGFloat = 0
            unselectedTags = tagService.getUnselectedTags(by: currentThing)
            if !unselectedTags.isEmpty {
                self.tagScrollView?.isHidden = false
                for tag in unselectedTags {
                    let tagButton = createExistingTagButton(with: tag.name, last: nil, last: nil)
                    tagScrollView.addSubview(tagButton)
                    tagButton.snp.makeConstraints({ (maker) in
                        maker.centerY.equalTo(tagScrollView!)
                        if let button = lastButton {
                            maker.left.equalTo(button.snp.right).offset(10)
                        } else {
                            maker.left.equalTo(tagScrollView!).offset(10)
                        }
                    })
                    tagButton.sizeToFit()
                    lastButton = tagButton
                    width += tagButton.frame.width + 10
                }
                tagScrollView.sizeToFit()
                tagScrollView.contentSize = CGSize(width: width, height: tagScrollView.frame.height)
            } else {
                tagScrollView.isHidden = true
            }
        }
    }
    
    func createExistingTagButton(with tag: String, last leftView: UIView?, last topView: UIView?) -> UIButton {
        let tagbutton = UIButton(type: .system)
        tagbutton.setTitle("#\(tag)", for: .normal)
        tagbutton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        tagbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tagbutton.setTitleColor(UIColor.remember, for: .normal)
        tagbutton.addTarget(self, action: #selector(TagManagementView.addExitingTagTap(sender:)), for: .touchUpInside)
        return tagbutton
    }
    
    @objc func addExitingTagTap(sender: UIButton) {
        if let tag = sender.titleLabel?.text?.trimmingCharacters(in: CharacterSet.init(charactersIn: "#")) {
            if let tagModel = unselectedTags.first(where: { (model) -> Bool in
                return model.name == tag
            }) {
                let thingTagModel = ThingTagModel(thingId: self.thing!.id, tagId: tagModel.id)
                tagService.saveThingTag(thingTagModel)
                var tempTagModel = tagModel
                tempTagModel.index += 1
                tagService.updateIndex(for: tempTagModel)
                selectedTags.append(tagModel)
                updateView(for: tag)
                changeTagButton(true)
                showUnselectedExistingTags()
                self.delegate?.tagManagement(view: self, tag: tag)
            }
        }
    }
    
    func updateView(with tag: String) {
        updateView(for: tag)
    }
    
    func updateView(by thing: ThingModel) {
        self.tagButtons.forEach { (button) in
            button.removeFromSuperview()
        }
        
        selectedTags = tagService.getSelectedTags(by: thing)
        if !selectedTags.isEmpty {
            for tag in selectedTags {
                updateView(for: tag.name)
            }
        }
    }
    
    private func updateView(for tag: String) {
        var leftView: UIView? = addTagButton
        var topView: UIView?
        
        if lastTagButton != nil {
            let rightPoint = lastTagButton!.frame.origin.x + lastTagButton!.frame.width
            let width = self.frame.width - rightPoint
            let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20.0)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let tagBounds = NSString(string: tag).boundingRect(with: size, options: option, attributes: attributes, context: nil)
            if width < 70 || width < tagBounds.width + 20 {
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
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func createNewTagButton(with tag: String, last leftView: UIView?, last topView: UIView?) -> UIButton {
        let tagbutton = UIButton(type: .system)
        tagbutton.setTitle(tag, for: .normal)
        tagbutton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        tagbutton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tagbutton.layer.cornerRadius = 10
        tagbutton.backgroundColor = UIColor.remember
        tagbutton.setTitleColor(UIColor.white, for: .normal)
        tagbutton.addTarget(self, action: #selector(TagManagementView.tagTap(sender:)), for: .touchUpInside)
        self.addSubview(tagbutton)
        tagbutton.snp.makeConstraints { (maker) in
            if leftView == nil {
                maker.left.equalTo(self).offset(10)
            } else {
                maker.left.equalTo(leftView!.snp.right).offset(10)
            }
            if topView == nil {
                maker.top.equalTo(self)
            } else {
                maker.top.equalTo(topView!.snp.bottom).offset(10)
            }
            maker.height.equalTo(20)
        }
        tagButtons.append(tagbutton)
        return tagbutton
    }
    
    @objc func tagTap(sender: UIButton) {
        if isEditing {
            if let tag = sender.titleLabel?.text {
                if let tagModel = selectedTags.first(where: { (model) -> Bool in
                    return model.name == tag
                }) {
                    let thingTagModel = ThingTagModel(thingId: self.thing!.id, tagId: tagModel.id)
                    tagService.deleteThingTag(thingTagModel)
                    lastTopView = nil
                    lastTagButton = nil
                    if tagModel.index > 0 {
                        var tempTagModel = tagModel
                        tempTagModel.index -= 1
                        tagService.updateIndex(for: tempTagModel)
                    }
                    updateView(by: self.thing!)
                    changeTagButton(true)
                    showUnselectedExistingTags()
                    self.delegate?.tagManagement(view: self, tag: tag)
                }
            }
        } else {
            startEdit()
        }
    }
    
    @objc func keyboardWillHide(_ notice: Notification) {
        self.tagScrollView?.isHidden = true
    }
    
    @objc func keyboardWillShow(_ notice: Notification) {
        if let endFrame = notice.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            //因为self的高度不对，所以只能这么计算y
            var y: CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2436:
                    y = endFrame.cgPointValue.y - self.frame.origin.y - 44 - 84
                default:
                    y = UIScreen.main.bounds.height - self.frame.origin.y - 44 - 64 - endFrame.cgRectValue.height
                }
            }
            self.tagScrollView?.frame = CGRect(x: 0, y: y, width: self.bounds.width, height: 44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TagManagementView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let tag = textField.text {
            let trimTag = tag.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if !trimTag.isEmpty {
                if !tagService.exists(trimTag) {
                    self.updateView(with: trimTag)
                    textField.text = ""
                    
                    saveTag(trimTag)
                    delegate?.tagManagement(view: self, tag: trimTag)
                }
            }
        }
        
        addTagTextField.isHidden = true
        addTagButton.isHidden = false
        endEdit()
        
        return true
    }
    
    private func saveTag(_ tag: String) {
        var tagModel = TagModel(name: tag)
        tagModel.index = 1
        let thingTagModel = ThingTagModel(thingId: self.thing!.id, tagId: tagModel.id)
        
        tagService.save(tagModel)
        tagService.saveThingTag(thingTagModel)
    }
}

protocol TagManagementDelegate: class {
    func tagManagement(view: TagManagementView, tag: String)
}
