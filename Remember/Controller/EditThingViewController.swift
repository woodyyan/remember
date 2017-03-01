//
//  EditThingViewController.swift
//  Remember
//
//  Created by Songbai Yan on 28/02/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit

class EditThingViewController: UIViewController {
    fileprivate var viewModel = EditThingViewModel()
    
    var thing:ThingEntity?
    var delegate:EditThingDelegate?
    var editView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "编辑"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.remember()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.remember()];
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EditThingViewController.doneEditClick(sender:)))
        
        initEditView()
    }
    
    func doneEditClick(sender:UIBarButtonItem){
        if let tempThing = thing{
            tempThing.content = editView.text
            self.viewModel.editThing(tempThing)
            delegate?.editThing(edit: true, thing: tempThing)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func initEditView(){
        editView = UITextView(frame: self.view.frame)
        editView.font = UIFont.systemFont(ofSize: 18)
        editView.textColor = UIColor.text()
        editView.text = thing?.content
        self.view.addSubview(editView)
        editView.becomeFirstResponder()
    }
}

protocol EditThingDelegate {
    func editThing(edit complete:Bool, thing:ThingEntity)
}
