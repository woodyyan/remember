//
//  HomeViewController+DZNEmptyDataSet.swift
//  Remember
//
//  Created by Songbai Yan on 03/04/2018.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import DZNEmptyDataSet

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "EmptyBox")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("addOneThing", comment: "")
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = NSLocalizedString("tips", comment: "提示")
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.remember]
        let tipsString = NSAttributedString(string: text, attributes: attributes)
        return tipsString
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        let tipsViewController = TipsViewController(style: .plain)
        self.navigationController?.pushViewController(tipsViewController, animated: true)
    }
}
