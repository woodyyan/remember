//
//  ViewController.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit

// swiftlint:disable file_length
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let inputViewHeight: CGFloat = 60
    private var shouldInputViewDisplay = true
    private var tableView: UITableView!
    private var snapshotView: UIView?
    private var tableHeaderView: UIView!
    private let pasteboardViewTag = 1234
    private var sourceIndexPath: IndexPath?
    private var inputThingView: InputThingView!
    
    private static let context = CoreStorage.shared.persistentContainer.viewContext
    
    let viewModel: HomeViewModel = ViewModelFactory.shared.create()
    
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
        
        initUI()
        
        initNotification()
        
        touchId()
    }
    
    private func initNotification() {
        let selector = #selector(HomeViewController.updatePasteboardView(_:))
        NotificationCenter.addObserver(self, selector, "updatePasteboardView")
        NotificationCenter.addObserver(self, #selector(HomeViewController.tagRemoved(_:)), "tagRemovedNotification")
    }
    
    private func initUI() {
        self.title = NSLocalizedString("appName", comment: "丁丁记事")
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.remember]
        self.navigationController?.navigationBar.tintColor = UIColor.remember
        
        let rightBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(HomeViewController.pushToSettingsPage(_:)))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.remember
        
        initTableView()
        initInputView()
        initTableHeaderView()
        initLongPressForTableView()
        setKeyboardNotification()
    }
    
    func beginCreateThing() {
        inputThingView.beginEditing()
    }
    
    @objc func updatePasteboardView(_ notification: Notification) {
        self.addPasteboardViewIfNeeded()
    }
    
    @objc func tagRemoved(_ notification: Notification) {
        self.tableView.reloadData()
    }
    
    private func setKeyboardNotification() {
        let showSelector = #selector(HomeViewController.keyboardWillShow(_:))
        NotificationCenter.addObserver(self, showSelector, UIResponder.keyboardWillShowNotification)
        let hideSelector = #selector(HomeViewController.keyboardWillHide(_:))
        NotificationCenter.addObserver(self, hideSelector, UIResponder.keyboardWillHideNotification)
    }
    
    private func initInputView() {
        let rect = CGRect(x: 0, y: self.height - inputViewHeight, width: self.width, height: inputViewHeight)
        inputThingView = InputThingView(frame: rect)
        inputThingView.delegate = self
        inputThingView.voiceInputAction = {(_) -> Void in
            self.showVoiceView()
        }
        self.view.addSubview(inputThingView)
    }
    
    private func showVoiceView() {
        let voiceInputController = VoiceInputController()
        voiceInputController.delegate = self
        voiceInputController.modalPresentationStyle = .custom
        voiceInputController.modalTransitionStyle = .crossDissolve
        self.present(voiceInputController, animated: false, completion: {
            voiceInputController.show()
        })
    }
    
    private func initTableHeaderView() {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 60))
        tableHeaderView.addSubview(getSearchButton())
        
        addPasteboardViewIfNeeded()
        
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func addPasteboardViewIfNeeded() {
        // 如果已经有粘贴板提示了就返回
        if self.tableHeaderView.viewWithTag(self.pasteboardViewTag) != nil {
            return
        }
        if let tempPasteContent = PasteboardUtils.getPasteboardContent() {
            // add timer
            addPasteDisappearTimer()
            self.viewModel.pasteContent = tempPasteContent
            self.tableView.beginUpdates()
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.width, height: 130)
            tableHeaderView.addSubview(getPasteBoardView(tempPasteContent))
            self.tableView.endUpdates()
        }
    }
    
    private func addPasteDisappearTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // 移除粘贴板提示
            if self.viewModel.pasteContent != nil {
                self.removePasteboardView()
            }
        }
    }
    
    private func getSearchButton() -> SearchButton {
        let frame = CGRect(x: 10, y: 10, width: self.width - 20, height: 40)
        let searchButton = SearchButton(frame: frame)
        searchButton.addTarget(self, action: #selector(HomeViewController.searchClick(_:)), for: UIControl.Event.touchUpInside)
        return searchButton
    }
    
    private func getPasteBoardView(_ content: String) -> UIView {
        viewModel.addPasteContentToSettings(content)
        
        let pasteboardView = PasteboardView(frame: CGRect(x: 10, y: 60, width: self.width - 20, height: 55))
        pasteboardView.okButton.addTarget(self, action: #selector(HomeViewController.pasteOkButtonClick(_:)), for: .touchUpInside)
        pasteboardView.pasteContentLabel.text = content
        pasteboardView.tag = pasteboardViewTag
        return pasteboardView
    }
    
    @objc func pasteOkButtonClick(_ sender: UIButton) {
        if self.viewModel.addPastContent() {
            tableView.reloadData()
        }
        
        removePasteboardView()
    }
    
    private func removePasteboardView() {
        // remove pasteboard
        self.tableView.beginUpdates()
        self.tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.width, height: 60)
        if let pasteboardView = self.tableHeaderView.viewWithTag(self.pasteboardViewTag) {
            pasteboardView.removeFromSuperview()
        }
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.endUpdates()
    }
    
    @objc func searchClick(_ sender: UIButton) {
        inputThingView.endEditing()
        
        let searchController = SearchViewController()
        searchController.homeController = self
        self.present(UINavigationController.init(rootViewController: searchController), animated: false, completion: nil)
    }
    
    private func initTableView() {
        let rect = CGRect(x: 0, y: 0, width: self.width, height: self.height - inputViewHeight)
        tableView = UITableView(frame: rect, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ThingTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.view.addSubview(tableView)
        
        // EmptyDataSet SDK
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    private func initLongPressForTableView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.longPressGestureRecognized(_:)))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressGestureRecognized(_ sender: AnyObject) {
        let longPress = sender as! UILongPressGestureRecognizer
        let state = longPress.state
        let location = longPress.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: location)
        
        switch state {
        case .began:
            if indexPath != nil {
                beganAnimate(indexPath: indexPath!, location: location)
            }
        case .changed:
            var center = snapshotView?.center
            center?.y = location.y
            snapshotView?.center = center!
            
            if indexPath != nil && !(indexPath == sourceIndexPath) {
                if let tempIndexPath = sourceIndexPath {
                    let index = self.viewModel.things[indexPath!.row].index
                    self.viewModel.things[indexPath!.row].index = self.viewModel.things[tempIndexPath.row].index
                    self.viewModel.things[tempIndexPath.row].index = index
                    self.viewModel.things.swapAt(indexPath!.row, tempIndexPath.row)
                    self.tableView.moveRow(at: tempIndexPath, to: indexPath!)
                    sourceIndexPath = indexPath
                }
            }
        default:
            if let tempIndexPath = sourceIndexPath {
                defaultAnimate(indexPath: tempIndexPath)
            }
        }
    }
    
    private func defaultAnimate(indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.snapshotView?.center = cell!.center
            self.snapshotView?.transform = CGAffineTransform.identity
            self.snapshotView?.alpha = 0.0
            cell?.alpha = 1.0
            self.viewModel.sortAndSaveThings()
            self.tableView.reloadData()
        }, completion: { (_) in
            cell?.isHidden = false
            self.sourceIndexPath = nil
            self.snapshotView?.removeFromSuperview()
            self.snapshotView = nil
        })
    }
    
    private func beganAnimate(indexPath: IndexPath, location: CGPoint) {
        sourceIndexPath = indexPath
        let cell = self.tableView.cellForRow(at: indexPath)
        snapshotView = self.customSnapshotFromView(cell!)
        
        var center = cell?.center
        snapshotView?.center = center!
        snapshotView?.alpha = 0.0
        self.tableView.addSubview(snapshotView!)
        
        UIView.animate(withDuration: 0.25, animations: {
            center?.y = location.y
            self.snapshotView?.center = center!
            self.snapshotView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.snapshotView?.alpha = 0.98
            cell?.alpha = 0.0
        }, completion: { (_) in
            cell?.isHidden = true
        })
    }
    
    func customSnapshotFromView(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    
    @objc func keyboardWillHide(_ notice: Notification) {
        if shouldInputViewDisplay {
            let y = self.height - inputViewHeight
            inputThingView.frame = CGRect(x: 0, y: y, width: self.width, height: inputViewHeight)
        }
    }
    
    @objc func keyboardWillShow(_ notice: Notification) {
        if shouldInputViewDisplay && inputThingView.isEditing() {
            if let userInfo = notice.userInfo {
                if let endFrameValue: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let endFrame = endFrameValue.cgRectValue
                    let y = self.height - inputViewHeight - endFrame.height
                    inputThingView.frame = CGRect(x: 0, y: y, width: self.width, height: inputViewHeight)
                }
            }
        }
    }
    
    @objc func pushToSettingsPage(_ sender: UIBarButtonItem) {
        inputThingView.endEditing()
        let settingsController = SettingsViewController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
}

extension HomeViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.things.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThingTableViewCell
        var thing = self.viewModel.things[indexPath.row]
        cell.textLabel?.text = thing.content
        cell.showTags(for: thing)
        cell.addTagAction = { () in
            self.editThing(thing, isTag: true)
        }
        cell.setBackground(style: viewModel.getCellBackgroundStyle(indexPath.row))
        if thing.isNew {
            cell.showAddTagButton()
            thing.isNew = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.calculateCellHeight(viewWidth: self.width, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let title = NSLocalizedString("tag", comment: "标签")
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: title) { (_, index) -> Void in
            let index = indexPath.row
            let thing = self.viewModel.things[index]
            self.editThing(thing, isTag: true)
            tableView.isEditing = false
        }
        
        let copyTitle = NSLocalizedString("copy", comment: "复制")
        let shareAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: copyTitle) { (_, index) -> Void in
            let index=(indexPath as NSIndexPath).row as Int
            let thing = self.viewModel.things[index]
            UIPasteboard.general.string = thing.content
        }
        shareAction.backgroundColor = UIColor.remember
        
        let deleteTitle = NSLocalizedString("delete", comment: "删除")
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: deleteTitle) { (_, index) -> Void in
            let alertController = UIAlertController(title: NSLocalizedString("sureToDelete", comment: "确定要删除吗？"),
                                                    message: NSLocalizedString("cannotRecovery", comment: ""), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "取消"), style: .cancel, handler: { _ in
                tableView.setEditing(false, animated: true)
            })
            let okAction = UIAlertAction(title: NSLocalizedString("confirmDelete", comment: "确认删除"), style: .destructive, handler: { _ in
                self.viewModel.deleteThing(index: (indexPath as NSIndexPath).row as Int)
                tableView.reloadData()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return [deleteAction, shareAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputThingView.endEditing()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let thing = self.viewModel.things[indexPath.row]
        openThingViewController(with: thing)
    }
    
    func openThingViewController(with thing: ThingModel) {
        let editController = EditThingViewController()
        editController.delegate = self
        editController.thing = thing
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputThingView.endEditing()
    }
    
    private func editThing(_ thing: ThingModel, isTag: Bool = false) {
        self.shouldInputViewDisplay = true
        
        let editController = EditThingViewController()
        editController.delegate = self
        editController.thing = thing
        editController.isEditTag = isTag
        self.navigationController?.pushViewController(editController, animated: true)
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        self.shouldInputViewDisplay = true
    }
}

extension HomeViewController: ThingInputDelegate {
    func input(inputView: InputThingView, thing: ThingModel) {
        self.viewModel.things.insert(thing, at: 0)
        self.viewModel.sortAndSaveThings()
        tableView.reloadData()
    }
}

extension HomeViewController: VoiceInputDelegate {
    func voiceInput(voiceInputView: VoiceInputController, thing: ThingModel) {
        self.viewModel.things.insert(thing, at: 0)
        self.viewModel.sortAndSaveThings()
        tableView.reloadData()
    }
}

extension HomeViewController: EditThingDelegate {
    func editThing(isDeleted: Bool, thing: ThingModel) {
        if isDeleted {
            if let index = self.viewModel.things.firstIndex(where: {$0.id == thing.id}) {
                self.viewModel.things.remove(at: index)
            }
        }
        self.viewModel.refreshThings()
        tableView.reloadData()
    }
}

extension HomeViewController: SearchResultTableDelegate {
    func searchResultTable(view: SearchResultTableViewController, thing: ThingModel) {
        openThingViewController(with: thing)
    }
}
