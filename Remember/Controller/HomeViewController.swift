//
//  ViewController.swift
//  Remember
//
//  Created by Songbai Yan on 14/11/2016.
//  Copyright © 2016 Songbai Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUI()
    }
    
    private func setUI(){
        self.title = "丁丁记事"
        self.view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white];
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 156/255, blue: 43/255, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关于", style: .plain, target: self, action: #selector(HomeViewController.pushToAboutPage(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        setInputView()
    }
    
    private func setInputView(){
        let inputView = InputView(frame: CGRect(x: 0, y: self.view.frame.height - 46, width: self.view.frame.width, height: 46))
        self.view.addSubview(inputView)
    }
    
    func pushToAboutPage(_ sender:UIBarButtonItem){
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

