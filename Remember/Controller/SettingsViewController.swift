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
    private let viewModel: SettingsViewModel = ViewModelFactory.shared.create()
    private let feedbackKit = BCFeedbackKit(appKey: GlobleConfigs.aliyunAppKey, appSecret: GlobleConfigs.aliyunAppSecret)
    
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
        self.navigationController?.navigationBar.tintColor = UIColor.remember
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.remember]
        
        tableView = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.background
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.gray
        let count = self.viewModel.getAllThingCount()
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
            return 5
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
            case 4:
                return getCell(.export)
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
            case 4:
                exportToCSV()
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
    
    private func commentAppInStore() {
        if let url = URL(string: GlobleConfigs.appStoreUrl) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([String: Any]()), completionHandler: nil)
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
    
    private func exportToCSV() {
        let fileUrl = viewModel.export()
        let controller = UIActivityViewController(activityItems: [fileUrl], applicationActivities: [])
        controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .saveToCameraRoll]
        self.present(controller, animated: true, completion: nil)
    }
    
    private func feedback() {
        feedbackKit?.extInfo = [
            "app_version": VersionUtils.getCurrentVersion(),
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
    
    private func recommandToFriends() {
        if let url = URL(string: GlobleConfigs.appStoreUrl) {
            let title = NSLocalizedString("recommendDescription", comment: "推荐")
            let controller = UIActivityViewController(activityItems: [title, url, UIImage.init(named: "icon")!], applicationActivities: [])
            controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks, .saveToCameraRoll]
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private func getCell(_ cellType: CellType) -> UITableViewCell {
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
        case .export:
            let exportCell = UITableViewCell(style: .value1, reuseIdentifier: "export")
            exportCell.accessoryType = .disclosureIndicator
            exportCell.textLabel?.text = NSLocalizedString("export", comment: "导出数据")
            exportCell.imageView?.image = #imageLiteral(resourceName: "export")
            return exportCell
        case .about:
            let newCell = UITableViewCell(style: .value1, reuseIdentifier: "about")
            newCell.textLabel?.text = NSLocalizedString("about", comment: "关于")
            newCell.imageView?.image = #imageLiteral(resourceName: "about_gray")
            newCell.detailTextLabel?.text = VersionUtils.getCurrentVersion()
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
        @unknown default:
            print(result)
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
    case export
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
