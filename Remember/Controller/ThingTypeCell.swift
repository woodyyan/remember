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

class ThingTypeCell: UITableViewCell {
    private let viewModel: ThingTableCellViewModel = ViewModelFactory.shared.create()
    
    private var shouldCustomizeActionButtons = false
    
    var titleLabel: UILabel?
    var numberLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        setBackground(type: .password)
        
//        var content = self.defaultContentConfiguration()
//        content.textProperties.font = UIFont.systemFont(ofSize: 20)
//        content.textProperties.color = .white
//        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: -20, leading: 40, bottom: 0, trailing: 0)
//        self.contentConfiguration = content
        
        titleLabel = UILabel()
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .left
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ make in
            make.left.equalTo(self.contentView).offset(50)
            make.top.equalTo(self.contentView).offset(30)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(20)
        })
        
        numberLabel = UILabel(frame: CGRect(x: 30, y: 20, width: 60, height: 20))
        numberLabel?.textColor = UIColor.white
        numberLabel?.textAlignment = .left
        numberLabel?.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(numberLabel!)
        numberLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(self.contentView).offset(50)
            maker.top.equalTo(titleLabel!.snp_topMargin).offset(30)
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
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.frame = CGRect(x: 30, y: 15, width: cellWidth - 60, height: cellHeight - 30)
        if let tag = numberLabel?.text {
            if !tag.isEmpty {
                self.textLabel?.sizeToFit()
            }
        }
    }
    
    func showCount(for thingType: ThingType) {
        numberLabel?.text = "123"
    }
    
    func setBackground(type: ThingType) {
        let backgroundView = getBackgroundImageView("accountpassword")
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func getBackgroundImageView(_ imageName: String) -> UIImageView {
        let image = UIImage(named: imageName)
        let insets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 40)
        let resizedImage = image?.resizableImage(withCapInsets: insets, resizingMode: UIImage.ResizingMode.stretch)
        let backImage =  UIImageView(image: resizedImage)
        return backImage
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
