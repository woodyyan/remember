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
    
    private let viewModel: MoreMenuViewModel = ViewModelFactory.shared.create()
    
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
        return viewModel.moreMenuSettings.numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.moreMenuSettings.heightForRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let textLabel = UILabel()
        textLabel.textColor = UIColor.remember
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textAlignment = .left
        let menuItem = viewModel.moreMenuSettings.getMenuItem(index: indexPath.row)
        textLabel.text = menuItem.text
        let imageView = UIImageView()
        imageView.image = UIImage(named: menuItem.imageName)
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

protocol MoreMenuViewDelegate: AnyObject {
    func moreMenuView(view: MoreMenuViewController, selectedAction: MoreMenuAction)
}
