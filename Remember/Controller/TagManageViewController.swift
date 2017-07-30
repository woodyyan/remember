//
//  TagManageViewController.swift
//  Remember
//
//  Created by Songbai Yan on 30/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class TagManageViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "标签管理"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
