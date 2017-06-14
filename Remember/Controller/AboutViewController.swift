//
//  AboutViewController.swift
//  Remember
//
//  Created by Songbai Yan on 10/01/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    private let viewModel = AboutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.remember()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.remember()];
        
        initTableView()
        initBottomView()
    }
    
    func initTableView(){
        let tableView = UITableView(frame: CGRect.init(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getTableViewCell(indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 66
        case 1:
            return 30
        case 2:
            return 44
        case 3:
            return 100
        case 4:
            return 54
        default:
            return 44
        }
    }
    
    private func initBottomView(){
        let bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 70, width: self.view.frame.width, height: 70))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
        lineView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        bottomView.addSubview(lineView)
        
        let feedbackButton = UIButton(type: UIButtonType.system)
        feedbackButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        feedbackButton.setTitle("反馈", for: UIControlState())
        feedbackButton.addTarget(self, action: #selector(AboutViewController.feedbackClick(_:)), for: .touchUpInside)
        
        //微博按钮
        let weiboButton = UIButton(type: UIButtonType.system)
        weiboButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        weiboButton.setTitle("微博", for: UIControlState())
        weiboButton.addTarget(self, action: #selector(AboutViewController.weiboClick(_:)), for: UIControlEvents.touchUpInside)
        
        let starStack = UIStackView(arrangedSubviews: [feedbackButton, weiboButton])
        starStack.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: 30)
        starStack.distribution = .fillEqually
        bottomView.addSubview(starStack)
        
        let companyLabel = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 15))
        companyLabel.text = "Copyright ©2017 略懂工作室 All Rights Reserved"
        companyLabel.textColor = UIColor.gray
        companyLabel.font = UIFont.systemFont(ofSize: 10)
        companyLabel.textAlignment = NSTextAlignment.center
        bottomView.addSubview(companyLabel)
    }
    
    func feedbackClick(_ sender:UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setSubject("丁丁记事反馈")
            mailComposerVC.setToRecipients(["easystudio@outlook.com"])
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            MessageBox.show("无法发送邮件")
        }
    }
    
    func weiboClick(_ sender:UIButton) {
        if let url = URL(string: "http://weibo.com/u/5613355795") {
            UIApplication.shared.open(url, options: [String : Any](), completionHandler: nil)
        }
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch(result){
        case MFMailComposeResult.sent:
            MessageBox.show("发送成功")
            break;
        case MFMailComposeResult.saved:
            break
        case MFMailComposeResult.cancelled:
            MessageBox.show("发送取消")
            break
        case MFMailComposeResult.failed:
            MessageBox.show("发送失败")
            break
        }
        controller.dismiss(animated: true, completion: nil)
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
            //介绍
            return getDescriptionCell()
        case 4:
            //版本号
            return getVersionCell()
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
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    private func getVersionCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.getVersionInfo()
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.lightGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
    
    private func getDescriptionCell() -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.getDescription()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.textAlignment = .justified
        return cell
    }
}
