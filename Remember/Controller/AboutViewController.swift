//
//  AboutViewController.swift
//  Remember
//
//  Created by Songbai Yan on 10/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UITableViewController {
    private let viewModel = AboutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.remember()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.remember()];
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getTableViewCell(indexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 66
        case 1:
            return 30
        case 2:
            return 44
        case 3:
            return 44
        case 4:
            return 70
        case 5:
            return 100
        default:
            return 44
        }
    }
    
    private func getTableViewCell(_ index:Int) -> UITableViewCell{
        switch index {
        case 0:
            //图标
            return getAppIconCell()
        case 1:
            //名字
            return getAppNameCell()
        case 2:
            //slogan：记住你容易忘记的小事
            return getSloganCell()
        case 3:
            //版本号
            return getVersionCell()
        case 4:
            //介绍
            return getDescriptionCell()
        case 5:
            //使用说明
            return getGettingStartedCell()
        default:
            return UITableViewCell()
        }
    }
    
    private func getAppIconCell() -> UITableViewCell{
        let logoImage = UIImageView(image: UIImage(named: "icon"))
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        logoImage.center.x = self.view.center.x
        cell.contentView.addSubview(logoImage)
        return cell
    }
    
    private func getAppNameCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.getAppName()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor(red: 247/255, green: 187/255, blue: 46/255, alpha: 1)
        return cell
    }
    
    private func getSloganCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.getSlogan()
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    private func getVersionCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.getVersionInfo()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
    
    private func getDescriptionCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let descriptionLabel = UILabel(frame: CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 70))
        descriptionLabel.text = viewModel.getDescription()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.textAlignment = .left
        cell.contentView.addSubview(descriptionLabel)
        return cell
    }
    
    private func getGettingStartedCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let gettingStartedLabel = UILabel(frame: CGRect(x: 40, y: 0, width: self.view.frame.width - 80, height: 90))
        gettingStartedLabel.text = viewModel.getGettingStarted()
        gettingStartedLabel.numberOfLines = 0
        gettingStartedLabel.font = UIFont.systemFont(ofSize: 12)
        gettingStartedLabel.textColor = UIColor.gray
        gettingStartedLabel.textAlignment = .left
        cell.contentView.addSubview(gettingStartedLabel)
        return cell
    }
}
