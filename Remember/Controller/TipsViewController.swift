//
//  TipsViewController.swift
//  Remember
//
//  Created by Songbai Yan on 10/03/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class TipsViewController: UITableViewController {
    private let viewModel: TipsViewModel = ViewModelFactory.shared.create()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("tips", comment: "提示")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTipCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = UIColor.text
        cell.imageView?.image = #imageLiteral(resourceName: "tiptopic")
        cell.textLabel?.attributedText = viewModel.getTipText(indexPath.row)
        return cell
    }
    
    private func buildTipView(text: String, image: UIImage, width: CGFloat) -> UIView {
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        textLabel.text = text
        textLabel.sizeToFit()
        
        let imageView = UIImageView(image: image)
        
        let tipView = UIStackView(arrangedSubviews: [textLabel, imageView])
        tipView.axis = .vertical
        tipView.frame = CGRect(x: 0, y: 0, width: width, height: textLabel.frame.height + imageView.frame.height)
        return tipView
    }
}
