//
//  SettingsViewController.swift
//  Remember
//
//  Created by Songbai Yan on 30/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import MessageUI
import NotificationBanner

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let service = AboutViewModel()
    private let feedbackKit = BCFeedbackKit(appKey: GlobleParameters.aliyunAppKey, appSecret: GlobleParameters.aliyunAppSecret)
    fileprivate var appStoreUrl = "https://itunes.apple.com/us/app/id1192994573"
    
    var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ALBBMANPageHitHelper.getInstance().pageAppear(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ALBBMANPageHitHelper.getInstance().pageDisAppear(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("settings", comment: "设置")
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.remember()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.remember()]
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.background()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.gray
        let thingService = ThingService()
        let count = thingService.getAllThingCount()
        let part1 = NSLocalizedString("totalThingsPart1", comment: "共记了")
        let part2 = NSLocalizedString("totalThingsPart2", comment: "件小事")
        descriptionLabel.text = "\(part1)\(count)\(part2)"
        tableView.tableHeaderView = descriptionLabel
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return getCell(.push)
        case 1:
            switch indexPath.row {
            case 0:
                return getCell(.tips)
            case 1:
                return getCell(.recommand)
            case 2:
                return getCell(.comment)
            case 3:
                return getCell(.feedback)
            default:
                return UITableViewCell()
            }
        case 2:
            return getCell(.about)
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let tagController = TagManageViewController()
            self.navigationController?.pushViewController(tagController, animated: true)
        case 1:
            switch indexPath.row {
            case 0:
                openTips()
            case 1:
                recommandToFriends()
            case 2:
                commentAppInStore()
            case 3:
                let cell = tableView.cellForRow(at: indexPath)
                cell?.detailTextLabel?.text = ""
                feedBackOrSendEmail()
            default:
                break
            }
        case 2:
            self.navigationController?.pushViewController(AboutViewController(), animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func openTips() {
        let controller = TipsViewController(style: .plain)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func commentAppInStore() {
        if let url = URL(string: appStoreUrl) {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        }
    }
    
    private func feedBackOrSendEmail() {
        let language = Locale.preferredLanguages[0]
        if language.hasPrefix("en") {
            sendEmail()
        } else {
            feedback()
        }
    }
    
    private func feedback() {
        feedbackKit?.extInfo = [
            "app_version": AboutViewModel().getCurrentVersion(),
            "device_model": UIDevice.current.model
        ]
        feedbackKit?.makeFeedbackViewController(completionBlock: { (controller, error) in
            print(error ?? "")
            if let feedbackController = controller {
                 self.navigationController?.pushViewController(feedbackController, animated: true)
                feedbackController.closeBlock = { controller in
                    controller?.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setSubject(NSLocalizedString("emailSubject", comment: "丁丁记事"))
            mailComposerVC.setToRecipients(["easystudio@outlook.com"])
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            let title = NSLocalizedString("cannotSendEmail", comment: "")
            let subTitle = NSLocalizedString("checkEmailConfig", comment: "")
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .warning)
            banner.show()
        }
    }
    
    fileprivate func recommandToFriends() {
        if let url = URL(string: appStoreUrl) {
            let title = NSLocalizedString("recommendDescription", comment: "推荐")
            let controller = UIActivityViewController(activityItems: [title, url, UIImage.init(named: "icon")!], applicationActivities: [])
            controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .saveToCameraRoll]
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func getCell(_ cellType: CellType) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        switch cellType {
        case .push:
            cell.textLabel?.text = NSLocalizedString("tagManager", comment: "标签管理")
            cell.imageView?.image = #imageLiteral(resourceName: "tag_gray")
        case .recommand:
            cell.textLabel?.text = NSLocalizedString("tellFriends", comment: "告诉小伙伴")
            cell.imageView?.image = #imageLiteral(resourceName: "share_gray")
        case .tips:
            cell.textLabel?.text = NSLocalizedString("tips", comment: "使用小提示")
            cell.imageView?.image = #imageLiteral(resourceName: "tips")
        case .comment:
            cell.textLabel?.text = NSLocalizedString("reviewInAppStore", comment: "给我们评分")
            cell.imageView?.image = #imageLiteral(resourceName: "like_gray")
        case .feedback:
            let feedbackCell = UITableViewCell(style: .value1, reuseIdentifier: "feedback")
            feedbackCell.accessoryType = .disclosureIndicator
            feedbackCell.textLabel?.text = NSLocalizedString("feedback", comment: "反馈与建议")
            feedbackCell.imageView?.image = #imageLiteral(resourceName: "feedback")
            feedbackKit?.getUnreadCount(completionBlock: { (count, _) in
                // swiftlint:disable empty_count
                if count == 0 {
                    feedbackCell.detailTextLabel?.text = ""
                } else {
                    feedbackCell.detailTextLabel?.text = String(count)
                }
            })
            return feedbackCell
        case .about:
            let newCell = UITableViewCell(style: .value1, reuseIdentifier: "about")
            newCell.textLabel?.text = NSLocalizedString("about", comment: "关于")
            newCell.imageView?.image = #imageLiteral(resourceName: "about_gray")
            newCell.detailTextLabel?.text = service.getCurrentVersion()
            newCell.accessoryType = .disclosureIndicator
            return newCell
        }
        return cell
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.sent:
            let title = NSLocalizedString("sendSuccess", comment: "")
            let subTitle = NSLocalizedString("willCheckLater", comment: "")
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .success)
            banner.show()
        case MFMailComposeResult.saved: break
        case MFMailComposeResult.cancelled: break
        case MFMailComposeResult.failed:
            let title = NSLocalizedString("sendFailed", comment: "")
            let subTitle = NSLocalizedString("checkEmailConfig", comment: "")
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .warning)
            banner.show()
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

private enum CellType {
    case push
    case recommand
    case comment
    case about
    case tips
    case feedback
}
