//
//  HomeViewController+TouchID.swift
//  Remember
//
//  Created by Songbai Yan  on 2019/10/27.
//  Copyright © 2019 Songbai Yan. All rights reserved.
//

import Foundation
import LocalAuthentication

extension HomeViewController {
    
    func touchId() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if let touchIdView = showFaceId() {
                evaluatePolicy(context, touchIdView: touchIdView)
            }
            
        } else if let code = error?.code {
            let message = self.viewModel.errorMessageForLAErrorCode(errorCode: code)
            print(message)
        }
    }
    
    private func evaluatePolicy(_ context: LAContext, touchIdView: UIView) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请用指纹解锁", reply: {success, error in
            if success {
                // 成功之后的逻辑， 通常使用多线程来实现跳转逻辑。
                print("Face ID successful!")
                DispatchQueue.main.async {
                    touchIdView.removeFromSuperview()
                }
            } else {
                if let error = error as NSError? {
                    // 获取错误信息
                    let message = self.viewModel.errorMessageForLAErrorCode(errorCode: error.code)
                    print(message)
                }
            }
        })
    }
    
    private func showFaceId() -> UIView? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return nil}
        let touchIDView = UIView()
        touchIDView.backgroundColor = UIColor.white
        touchIDView.frame = window.frame
        touchIDView.center = window.center
        window.addSubview(touchIDView)
        
        let fingerprintButton = UIButton(type: UIButton.ButtonType.system)
        fingerprintButton.setImage(#imageLiteral(resourceName: "fingerprint"), for: UIControl.State.normal)
        fingerprintButton.addTarget(self, action: #selector(self.touchId(sender:)), for: UIControl.Event.touchUpInside)
        touchIDView.addSubview(fingerprintButton)
        fingerprintButton.snp.makeConstraints { (make) in
            make.center.equalTo(touchIDView)
        }
        
        let faceIdButton = UIButton(type: UIButton.ButtonType.system)
        faceIdButton.setTitle(NSLocalizedString("clickToTouchId", comment: "点击进行指纹解锁"), for: UIControl.State.normal)
        faceIdButton.addTarget(self, action: #selector(self.touchId(sender:)), for: UIControl.Event.touchUpInside)
        touchIDView.addSubview(faceIdButton)
        faceIdButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(fingerprintButton)
            make.top.equalTo(fingerprintButton.snp.bottom).offset(10)
        }
        return touchIDView
    }
    
    @objc func touchId(sender: UIButton) {
        if let touchIdView = sender.superview {
            evaluatePolicy(LAContext(), touchIdView: touchIdView)
        }
    }
}
