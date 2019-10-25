//
//  ThingTableViewCell.swift
//  Remember
//
//  Created by Songbai Yan on 18/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ThingTableViewCell: UITableViewCell {
    private let viewModel: ThingTableCellViewModel = ViewModelFactory.shared.create()
    
    private var shouldCustomizeActionButtons = false
    
    var tagLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        setBackground(style: .normal)
        
        tagLabel = UILabel(frame: CGRect(x: 30, y: 20, width: 60, height: 20))
        tagLabel?.textColor = UIColor.tag
        tagLabel?.textAlignment = .right
        tagLabel?.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(tagLabel!)
        tagLabel?.snp.makeConstraints({ (maker) in
            maker.bottom.equalTo(self).offset(-5)
            maker.right.equalTo(self).offset(-25)
            maker.width.lessThanOrEqualTo(300)
            maker.height.equalTo(20)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        
        let cellHeight = self.frame.size.height
        let cellWidth = self.frame.size.width
        self.textLabel?.numberOfLines = 0
        self.textLabel?.textColor = UIColor.text
        self.textLabel?.frame = CGRect(x: 30, y: 15, width: cellWidth - 60, height: cellHeight - 30)
        if let tag = tagLabel?.text {
            if !tag.isEmpty {
                self.textLabel?.sizeToFit()
            }
        }
        
        customizeActionButtons()
    }
    
    func showAddTagButton() {
        let addTagButton = UIButton(type: .system)
        addTagButton.setTitle(NSLocalizedString("addTag", comment: ""), for: .normal)
        addTagButton.addTarget(self, action: #selector(ThingTableViewCell.addTagTap(sender:)), for: .touchUpInside)
        addTagButton.layer.cornerRadius = 10
        addTagButton.layer.shadowColor = UIColor.black.cgColor
        addTagButton.layer.shadowOpacity = 0.8
        addTagButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        addTagButton.alpha = 0
        addTagButton.backgroundColor = UIColor.remember
        addTagButton.setTitleColor(UIColor.white, for: .normal)
        addTagButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(addTagButton)
        addTagButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-30)
            maker.centerY.equalTo(self)
            maker.height.equalTo(20)
            maker.width.equalTo(70)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .allowAnimatedContent, animations: {
            addTagButton.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // 移除添加标签按钮
            UIView.animate(withDuration: 0.5, animations: {
                addTagButton.alpha = 0
            }, completion: { (_) in
                addTagButton.removeFromSuperview()
            })
        }
    }
    
    var addTagAction: (() -> Swift.Void)?
    
    @objc func addTagTap(sender: UIButton) {
        addTagAction?()
        sender.removeFromSuperview()
    }
    
    private func customizeActionButtons() {
        for subView in self.subviews {
            if NSClassFromString("UITableViewCellDeleteConfirmationView") != nil {
                if subView.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
                    if shouldCustomizeActionButtons {
                        subView.backgroundColor = UIColor.clear
                        if subView.subviews.count == 3 {
                            let deleteButton = subView.subviews[0]
                            let deleteLabel = deleteButton.subviews[0]
                            if deleteLabel.isKind(of: NSClassFromString("UIButtonLabel")!) {
                                deleteLabel.removeFromSuperview()
                            }
                            deleteButton.backgroundColor = UIColor.clear
                            let deleteImage = UIImageView(image: UIImage(named: "delete"))
                            deleteButton.addSubview(deleteImage)
                            deleteImage.snp.makeConstraints({ (maker) in
                                maker.center.equalTo(deleteButton)
                            })
                            
                            let shareButton = subView.subviews[1]
                            let shareLabel = shareButton.subviews[0]
                            if shareLabel.isKind(of: NSClassFromString("UIButtonLabel")!) {
                                shareLabel.removeFromSuperview()
                            }
                            shareButton.backgroundColor = UIColor.clear
                            let shareImage = UIImageView(image: UIImage(named: "share"))
                            shareButton.addSubview(shareImage)
                            shareImage.snp.makeConstraints({ (maker) in
                                maker.center.equalTo(shareButton)
                            })
                            
                            let tagButton = subView.subviews[2]
                            let tagLabel = tagButton.subviews[0]
                            if tagLabel.isKind(of: NSClassFromString("UIButtonLabel")!) {
                                tagLabel.removeFromSuperview()
                            }
                            tagButton.backgroundColor = UIColor.clear
                            let tagImage = UIImageView(image: UIImage(named: "tag"))
                            tagButton.addSubview(tagImage)
                            tagImage.snp.makeConstraints({ (maker) in
                                maker.center.equalTo(tagButton)
                            })
                        }
                    }
                }
            }
        }
    }
    
    override func willTransition(to state: UITableViewCell.StateMask) {
        if state == UITableViewCell.StateMask.showingDeleteConfirmation {
            shouldCustomizeActionButtons = true
        } else {
            self.shouldCustomizeActionButtons = false
        }
    }
    
    func showTags(for thing: ThingModel) {
        tagLabel?.text = viewModel.getJointTagText(for: thing)
    }
    
    func setBackground(style: ThingCellBackgroundStyle) {
        switch style {
        case .first:
            self.backgroundView = getBackgroundImageView("FirstCellBackground")
        case .last:
            self.backgroundView = getBackgroundImageView("LastCellBackground")
        case .normal:
            self.backgroundView = getBackgroundImageView("CellBackground")
        case .one:
            self.backgroundView = getBackgroundImageView("OneCellBackground")
        }
    }
    
    private func getBackgroundImageView(_ imageName: String) -> UIImageView {
        let image = UIImage(named: imageName)
        let insets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        let resizedImage = image?.resizableImage(withCapInsets: insets, resizingMode: UIImage.ResizingMode.stretch)
        let backImage =  UIImageView(image: resizedImage)
        return backImage
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if [#selector(copyText)].contains(action) {
//            return true
//        }
//        return false
//    }
    
//    func showMenuItems() {
//        self.becomeFirstResponder() // 这句很重要
//        let menuController = UIMenuController.shared
//        let copyItem = UIMenuItem(title: "复制", action: #selector(copyText))
//        menuController.menuItems = [copyItem]
//        menuController.setTargetRect(frame, in: superview!)
//        menuController.setMenuVisible(true, animated: true)
//    }
    
//    @objc func copyText() {
//        UIPasteboard.general.string = self.textLabel?.text
//        UserDefaults.standard.set(self.textLabel?.text, forKey: "pasteboardContent")
//        UserDefaults.standard.synchronize()
//    }
}

class ThingLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        super.drawText(in: rect.inset(by: insets))
    }
}
