//
//  EditThingViewController.swift
//  Remember
//
//  Created by Songbai Yan on 28/02/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SCLAlertView

class EditThingViewController: UIViewController {
    private let viewModel: EditThingViewModel = ViewModelFactory.shared.create()
    
    var isEditTag = false
    var thing: ThingModel?
    weak var delegate: EditThingDelegate?
    var editView: UITextView!
    var scrollView: UIScrollView!
    var tagManagementView: TagManagementView!
    
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
        
        self.title = NSLocalizedString("edit", comment: "编辑")
        self.view.backgroundColor = UIColor.background
        self.navigationController?.navigationBar.tintColor = UIColor.remember
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.remember]
        
        let moreSelector = #selector(EditThingViewController.moreTap(sender:))
        let moreItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: UIBarButtonItemStyle.plain, target: self, action: moreSelector)
        self.navigationItem.rightBarButtonItem = moreItem
        
        initUI()
    }
    
    @objc func moreTap(sender: UIBarButtonItem) {
        let vc = MoreMenuViewController(style: .grouped)
        vc.delegate = self
        let language = viewModel.getCurrentLanguage()
        if language == Language.EN {
            vc.preferredContentSize = CGSize(width: 110, height: 120)
        } else {
            vc.preferredContentSize = CGSize(width: 90, height: 120)
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        vc.popoverPresentationController?.barButtonItem = sender
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.backgroundColor = UIColor.white
        self.present(vc, animated: true, completion: nil)
    }
    
    private func initUI() {
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        let createdDateLabel = UILabel()
        createdDateLabel.text = getCreatedDateText()
        createdDateLabel.textColor = UIColor.gray
        createdDateLabel.font = UIFont.systemFont(ofSize: 10)
        scrollView.addSubview(createdDateLabel)
        createdDateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView).offset(20)
            maker.left.equalTo(scrollView).offset(15)
        }
        
        initEditView(createdDateLabel: createdDateLabel)
        
        tagManagementView = TagManagementView(frame: CGRect(x: 0, y: 200, width: 375, height: 300))
        tagManagementView.delegate = self
        tagManagementView.thing = self.thing
        scrollView.addSubview(tagManagementView)
        tagManagementView.snp.makeConstraints { (maker) in
            maker.top.equalTo(editView.snp.bottom).offset(10)
            maker.width.equalTo(scrollView)
            maker.left.equalTo(scrollView)
            maker.right.equalTo(scrollView)
            maker.height.equalTo(600)
        }
        
        showAddedTags()
        
        if isEditTag {
            tagManagementView.startEdit()
        }
    }
    
    private func initEditView(createdDateLabel: UILabel) {
        editView = UITextView()
        editView.font = UIFont.systemFont(ofSize: 18)
        editView.layer.cornerRadius = 8
        editView.backgroundColor = UIColor.white
        editView.textColor = UIColor.text
        editView.text = thing?.content
        editView.returnKeyType = .done
        editView.delegate = self
        scrollView.addSubview(editView)
        editView.snp.makeConstraints { (maker) in
            maker.top.equalTo(createdDateLabel.snp.bottom).offset(10)
            maker.left.equalTo(scrollView).offset(10)
            maker.height.greaterThanOrEqualTo(100)
            maker.width.equalTo(scrollView.frame.width - 20)
        }
    }
    
    private func showAddedTags() {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        if let currentThing = self.thing {
            self.tagManagementView.updateView(by: currentThing)
        }
    }
    
    private func getCreatedDateText() -> String {
        return thing?.createdAt.toDateText() ?? ""
    }
    
    private func getActivityViewController(content: String) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: [content], applicationActivities: [])
        activityController.excludedActivityTypes = [.openInIBooks, .addToReadingList, .saveToCameraRoll]
        activityController.completionWithItemsHandler = {
            (type, flag, array, error) -> Swift.Void in
            print(type ?? "")
        }
        return activityController
    }
}

extension EditThingViewController: TagManagementDelegate {
    func tagManagement(view: TagManagementView, tag: String) {
        if let currentThing = thing {
            delegate?.editThing(isDeleted: false, thing: currentThing)
        }
    }
}

extension EditThingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            if thing != nil {
                thing?.content = editView.text
                self.viewModel.edit(thing!)
                delegate?.editThing(isDeleted: false, thing: thing!)
            }
            return false
        }
        return true
    }
}

extension EditThingViewController: MoreMenuViewDelegate {
    func moreMenuView(view: MoreMenuViewController, selectedAction: MoreMenuAction) {
        switch selectedAction {
        case .share:
            self.share()
        case .copy:
            self.copyThing()
        case .password:
            self.addOrRemovePassword()
        case .delete:
            self.delete()
        }
    }
    
    private func addOrRemovePassword() {
        
    }
    
    private func copyThing() {
        if let content = thing?.content {
            UIPasteboard.general.string = content
        }
    }
    
    private func share() {
        if let content = thing?.content {
            let activityController = getActivityViewController(content: content)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    private func delete() {
        self.editView.resignFirstResponder()
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let backgroundColor = UIColor(red: 251/255, green: 103/255, blue: 83/255, alpha: 1)
        let title = NSLocalizedString("confirmDelete", comment: "")
        alertView.addButton(title, backgroundColor: backgroundColor, textColor: UIColor.white, showTimeout: nil, action: {
            if let currentThing = self.thing {
                self.viewModel.delete(currentThing)
                self.delegate?.editThing(isDeleted: true, thing: currentThing)
                self.navigationController?.popViewController(animated: true)
            }
        })
        let cancelTitle = NSLocalizedString("cancel", comment: "取消")
        alertView.addButton(cancelTitle, backgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8156862745, blue: 0.2039215686, alpha: 1), textColor: UIColor.white, showTimeout: nil, action: {
        })
        
        alertView.showWarning(NSLocalizedString("sureToDelete", comment: ""), subTitle: NSLocalizedString("cannotRecovery", comment: ""))
    }
}

extension EditThingViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

protocol EditThingDelegate: class {
    func editThing(isDeleted: Bool, thing: ThingModel)
}
