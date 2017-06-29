//
//  ThingTableViewCell.swift
//  Remember
//
//  Created by Songbai Yan on 18/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class ThingTableViewCell: UITableViewCell {
    
    private var shouldCustomizeActionButtons = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        setBackground(style: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        
        let cellHeight = self.frame.size.height;
        let cellWidth = self.frame.size.width;
        self.textLabel?.numberOfLines = 0
        self.textLabel?.textColor = UIColor.text()
        self.textLabel?.frame = CGRect(x: 30, y: 15, width: cellWidth - 60, height: cellHeight - 30)
        
        customizeActionButtons()
    }
    
    private func customizeActionButtons(){
        for subView in self.subviews {
            if subView.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!){
                if shouldCustomizeActionButtons{
                    subView.backgroundColor = UIColor.clear
                    if subView.subviews.count == 3{
                        let deleteButton = subView.subviews[0]
                        let deleteLabel = deleteButton.subviews[0]
                        if deleteLabel.isKind(of: NSClassFromString("UIButtonLabel")!){
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
                        if shareLabel.isKind(of: NSClassFromString("UIButtonLabel")!){
                            shareLabel.removeFromSuperview()
                        }
                        shareButton.backgroundColor = UIColor.clear
                        let shareImage = UIImageView(image: UIImage(named: "share"))
                        shareButton.addSubview(shareImage)
                        shareImage.snp.makeConstraints({ (maker) in
                            maker.center.equalTo(shareButton)
                        })
                        
                        let editButton = subView.subviews[2]
                        let editLabel = editButton.subviews[0]
                        if editLabel.isKind(of: NSClassFromString("UIButtonLabel")!){
                            editLabel.removeFromSuperview()
                        }
                        editButton.backgroundColor = UIColor.clear
                        let editImage = UIImageView(image: UIImage(named: "edit"))
                        editButton.addSubview(editImage)
                        editImage.snp.makeConstraints({ (maker) in
                            maker.center.equalTo(editButton)
                        })
                    }
                }
            }
        }
    }
    
    override func willTransition(to state: UITableViewCellStateMask) {
        if state == UITableViewCellStateMask.showingDeleteConfirmationMask{
            shouldCustomizeActionButtons = true
        }else{
            self.shouldCustomizeActionButtons = false
        }
    }
    
    func setBackground(style:ThingCellBackgroundStyle){
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
    
    private func getBackgroundImageView(_ imageName:String) -> UIImageView{
        let image = UIImage(named: imageName)
        let resizedImage = image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), resizingMode: UIImageResizingMode.stretch)
        let backImage =  UIImageView(image: resizedImage)
        return backImage
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if [#selector(copyText)].contains(action) {
            return true
        }
        return false
    }
    
    func showMenuItems() {
        self.becomeFirstResponder() // 这句很重要
        let menuController = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(copyText))
        menuController.menuItems = [copyItem]
        menuController.setTargetRect(frame, in: superview!)
        menuController.setMenuVisible(true, animated: true)
    }
    
    func copyText() {
        UIPasteboard.general.string = self.textLabel?.text
        UserDefaults.standard.set(self.textLabel?.text, forKey: "pasteboardContent")
        UserDefaults.standard.synchronize()
    }
}

enum ThingCellBackgroundStyle : Int {
    case normal //正常情况，四个缺角
    case first //第一个cell，只有下面两个缺角
    case last //最后一个cell，只有上面两个缺角
    case one //只有一个cell，没有缺角
}

class ThingLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
