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
    private var lastTopView:UIView?
    private var lastTagButton:UIView?
    private var tagLabel:UILabel!
    
    fileprivate let tagService = TagService()
    
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
        
        tagLabel = UILabel()
        tagLabel.text = "常用标签"
        tagLabel.textColor = UIColor.gray
        tagLabel.font = UIFont.systemFont(ofSize: 12)
        self.view.addSubview(tagLabel)
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
        self.view.addSubview(tagbutton)
        tagbutton.snp.makeConstraints { (maker) in
            if leftView == nil{
                maker.left.equalTo(self.view).offset(20)
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

extension SearchViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let content = textField.text{
            if !content.isEmpty{
                print("search")
            }
        }
        
        return true
    }
}
