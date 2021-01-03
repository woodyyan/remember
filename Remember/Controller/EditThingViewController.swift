//
//  EditThingViewController.swift
//  Remember
//
//  Created by Songbai Yan on 28/02/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class EditThingViewController: UIViewController {
    private let viewModel: EditThingViewModel = ViewModelFactory.shared.create()
    
    var isEditTag = false
    var thing: ThingModel?
    weak var delegate: EditThingDelegate?
    var editView: TitledEditView!
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.remember]
        
        let moreSelector = #selector(EditThingViewController.moreTap(sender:))
        let moreItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: UIBarButtonItem.Style.plain, target: self, action: moreSelector)
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
        
        let contentView = TitledEditView(frame: .zero)
        contentView.title = getCreatedDateText()
        contentView.content = thing?.content
        contentView.delegate = self
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView).offset(20)
            $0.left.equalTo(scrollView).offset(10)
            $0.height.greaterThanOrEqualTo(120)
            $0.width.equalTo(scrollView.frame.width - 20)
        }
        
        tagManagementView = TagManagementView(frame: CGRect(x: 0, y: 200, width: 375, height: 300))
        tagManagementView.delegate = self
        tagManagementView.thing = self.thing
        scrollView.addSubview(tagManagementView)
        tagManagementView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.bottom).offset(10)
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

extension EditThingViewController: TitledEditViewDelegate {
    func titledEditView(_ textView: TitledEditView, shouldChangeTextIn range: NSRange, replacementText text: String) {
        if text == "\n"{
            textView.resignFirstResponder()
            if thing != nil {
                thing?.content = textView.content ?? ""
                self.viewModel.edit(thing!)
                delegate?.editThing(isDeleted: false, thing: thing!)
            }
        }
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
        let alertController = UIAlertController(title: NSLocalizedString("sureToDelete", comment: "确定要删除吗？"),
                                                message: NSLocalizedString("cannotRecovery", comment: ""), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "取消"), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("confirmDelete", comment: "确认删除"), style: .destructive, handler: { _ in
            if let currentThing = self.thing {
                self.viewModel.delete(currentThing)
                self.delegate?.editThing(isDeleted: true, thing: currentThing)
                self.navigationController?.popViewController(animated: true)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
