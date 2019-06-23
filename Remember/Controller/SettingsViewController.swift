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
        
        self.viewModel.initSettings()
        
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
        return viewModel.settings.sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        let item = viewModel.settings.getSettingItem(indexPath)
        cell.textLabel?.text = item.title
        cell.imageView?.image = UIImage(named: item.icon)
        cell.detailTextLabel?.text = item.detailText
        return cell
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

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
