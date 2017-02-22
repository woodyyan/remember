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
        self.textLabel?.textAlignment = .justified
        self.textLabel?.frame = CGRect(x: 30, y: 15, width: cellWidth - 60, height: cellHeight - 30)
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
