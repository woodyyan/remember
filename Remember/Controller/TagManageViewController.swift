//
//  TagManageViewController.swift
//  Remember
//
//  Created by Songbai Yan on 30/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
//import SCLAlertView
import DZNEmptyDataSet

class TagManageViewController: UITableViewController {
    private var tags = [TagModel]()
    
    private static let context = CoreStorage.shared.persistentContainer.viewContext
    private let viewModel = TagManagementViewControllerModel(tagStorage: TagStorage(context: context), thingTagStorage: ThingTagStorage(context: context))
    
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
        
        self.title = NSLocalizedString("tagManager", comment: "标签管理")
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        // EmptyDataSet SDK
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        let rightBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "edit"), style: .plain, target: self, action: #selector(TagManageViewController.editTags(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.tags = self.viewModel.getAllTags()
    }
    
    @objc func editTags(sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let tagName = self.tags[indexPath.row].name
        cell.textLabel?.text = "#" + tagName!
        cell.textLabel?.textColor = UIColor.text
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = #imageLiteral(resourceName: "tag_gray")
        let count = self.viewModel.getThingCount(byTag: tagName!)
        cell.detailTextLabel?.text = "\(count)\(NSLocalizedString("things", comment: "件小事"))"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tags.count > indexPath.row {
            let content: NSString = self.tags[indexPath.row].name as NSString
            let expectSize = CGSize(width: self.view.frame.width - 30, height: CGFloat.greatestFiniteMagnitude)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let size = content.boundingRect(with: expectSize, options: option, attributes: attributes, context: nil)
            return size.height + 30
        } else {
            return UITableViewCell().frame.height
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let title = NSLocalizedString("delete", comment: "删除")
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: title) { (action, index) -> Void in
            
//            let appearance = SCLAlertView.SCLAppearance(
//                showCloseButton: false
//            )
//            let alertView = SCLAlertView(appearance: appearance)
//            let color = UIColor(red: 251/255, green: 103/255, blue: 83/255, alpha: 1)
//            let deleteTitle = NSLocalizedString("confirmDelete", comment: "确认删除")
//            alertView.addButton(deleteTitle, backgroundColor: color, textColor: UIColor.white, showTimeout: nil, action: {
//                let index=(indexPath as NSIndexPath).row as Int
//                let tag = self.tags[index]
//                self.tags.remove(at: index)
//                self.tagService.deleteTag(tag)
//                tableView.reloadData()
//                self.sendNotification(with: tag)
//            })
//            let cancelColor = UIColor(red: 254/255, green: 208/255, blue: 52/255, alpha: 1)
//            let cancelTitle = NSLocalizedString("cancel", comment: "取消")
//            alertView.addButton(cancelTitle, backgroundColor: cancelColor, textColor: UIColor.white, showTimeout: nil, action: {
//                tableView.setEditing(false, animated: true)
//            })
//            let subTitle = NSLocalizedString("deleteTagNotDeleteThing", comment: "删除提示")
//            alertView.showWarning(NSLocalizedString("sureToDelete", comment: "确定要删除吗？"), subTitle: subTitle)
        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    private func sendNotification(with tag: TagModel) {
        let notify = Notification(name: Notification.Name(rawValue: "tagRemovedNotification"), object: tag, userInfo: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tagRemovedNotification"), object: notify)
    }
}

extension TagManageViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "tag")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: NSLocalizedString("noTag", comment: "没有标签"), attributes: attributes)
    }
}
