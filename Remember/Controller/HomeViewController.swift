//
//  ViewController.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let inputViewHeight: CGFloat = 60
    private var shouldInputViewDisplay = true
    private var tableView: UITableView!
    private var snapshotView: UIView?
    private var tableHeaderView: UIView!
    private var sourceIndexPath: IndexPath?
    private var inputThingView: InputThingView!
    
    private static let context = CoreStorage.shared.persistentContainer.viewContext
    
    let viewModel: HomeViewModel = ViewModelFactory.shared.create()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        initNotification()
        
        touchId()
    }
    
    private func initNotification() {
        NotificationCenter.addObserver(self, #selector(HomeViewController.tagRemoved(_:)), "tagRemovedNotification")
    }
    
    private func initUI() {
        self.title = NSLocalizedString("appName", comment: "伍迪收纳盒")
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.remember]
        self.navigationController?.navigationBar.tintColor = UIColor.remember
        
        let rightBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(HomeViewController.pushToSettingsPage(_:)))
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.remember
        
        initTableView()
        initInputView()
        initTableHeaderView()
//        initLongPressForTableView()
        setKeyboardNotification()
    }
    
    func beginCreateThing() {
        inputThingView.beginEditing()
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
        
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func getSearchButton() -> SearchButton {
        let frame = CGRect(x: 10, y: 10, width: self.width - 20, height: 40)
        let searchButton = SearchButton(frame: frame)
        searchButton.addTarget(self, action: #selector(HomeViewController.searchClick(_:)), for: UIControl.Event.touchUpInside)
        return searchButton
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
        tableView.register(ThingTypeCell.self, forCellReuseIdentifier: "cell")
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
        return viewModel.thingTypes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThingTypeCell
        let thingType = viewModel.thingTypes[indexPath.row]
        cell.setBackground(type: thingType.type)
        cell.titleLabel?.text = thingType.name
        cell.showCount(for: .password)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.width - 40)/3.52 + 10 // 3.52是图片的宽高比
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputThingView.endEditing()
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let thing = self.viewModel.things[indexPath.row]
//        openThingViewController(with: thing)
    }
    
    func openThingViewController(with thing: ThingModel) {
        let editController = EditThingViewController()
        editController.delegate = self
        editController.thing = thing
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
