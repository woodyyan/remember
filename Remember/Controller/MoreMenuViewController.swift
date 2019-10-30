//
//  MoreMenuViewController.swift
//  Remember
//
//  Created by Songbai Yan on 2018/5/6.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class MoreMenuViewController: UITableViewController {
    
    weak var delegate: MoreMenuViewDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ALBBMANPageHitHelper.getInstance().pageAppear(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ALBBMANPageHitHelper.getInstance().pageDisAppear(self)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: UITableView.Style.grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 13))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let action = MoreMenuAction(rawValue: indexPath.row)
            self.delegate?.moreMenuView(view: self, selectedAction: action!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let textLabel = UILabel()
        textLabel.textColor = UIColor.remember
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textAlignment = .left
        let imageView = UIImageView()
        switch indexPath.row {
        case 0:
            textLabel.text = NSLocalizedString("share", comment: "分享")
            imageView.image = #imageLiteral(resourceName: "share")
        case 1:
            textLabel.text = NSLocalizedString("copy", comment: "复制")
            imageView.image = #imageLiteral(resourceName: "copy")
//        case 2:
//            textLabel.text = NSLocalizedString("password", comment: "密码")
//            imageView.image = #imageLiteral(resourceName: "password")
        case 2:
            textLabel.text = NSLocalizedString("delete", comment: "删除")
            imageView.image = #imageLiteral(resourceName: "delete")
        default: break
        }
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(textLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(cell).offset(15)
            make.centerY.equalTo(cell)
            make.width.height.equalTo(16)
        }
        textLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.right.equalTo(cell)
            make.centerY.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        return cell
    }
}

enum MoreMenuAction: Int {
    case share = 0
    case copy = 1
//    case password = 2
    case delete = 2
}

protocol MoreMenuViewDelegate: class {
    func moreMenuView(view: MoreMenuViewController, selectedAction: MoreMenuAction)
}
