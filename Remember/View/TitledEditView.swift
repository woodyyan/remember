//
//  TitledEditView.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/11/7.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import UIKit

class TitledEditView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let titleLabel = UILabel()
    private let editView = UITextView()
    
    weak var delegate: TitledEditViewDelegate?
    
    var content: String? {
        get {
            return editView.text
        }
        set {
            editView.text = newValue
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    private func setupUI() {
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.left.equalTo(self).offset(5)
        }
        
        editView.font = UIFont.systemFont(ofSize: 18)
        editView.layer.cornerRadius = 8
        editView.backgroundColor = UIColor.white
        editView.textColor = UIColor.text
        editView.returnKeyType = .done
        editView.delegate = self
        self.addSubview(editView)
        editView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.left.equalTo(self)
            maker.bottom.equalTo(self)
            maker.width.equalTo(self)
        }
    }
}

extension TitledEditView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.delegate?.titledEditView(self, shouldChangeTextIn: range, replacementText: text)
            return false
        }
        return true
    }
}

protocol TitledEditViewDelegate: NSObjectProtocol {
    func titledEditView(_ textView: TitledEditView, shouldChangeTextIn range: NSRange, replacementText text: String)
}
