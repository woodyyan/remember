//
//  VoiceInputController.swift
//  Remember
//
//  Created by Songbai Yan on 06/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Speech

class VoiceInputController: UIViewController, UIGestureRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-CN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var hasText = false
    
    fileprivate var viewModel: VoiceInputViewModel = ViewModelFactory.shared.create()
    fileprivate let backgroundView = UIView()
    fileprivate var textView = UITextView()
    
    weak var delegate: VoiceInputDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer?.delegate = self
        
        requestAuthorization()
        initUI()
        addDismissGesture()
        
        startRecording()
    }
    
    func startRecording() {
        
        resetRecognitionTask()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.record)))
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.hasText = true
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = NSLocalizedString("sayThing", comment: "")
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {
            case .authorized:
                print("Authorized")
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Speech recognition restricted on this device")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            @unknown default:
                print(authStatus)
            }
        }
    }
    
    private func initUI() {
        // 一个cell的高度
        let height = (self.view.frame.width)/2
        
        backgroundView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        self.view.addSubview(backgroundView)
        let size = CGSize(width: self.view.frame.width, height: height)
        backgroundView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: size)
        
        let voiceView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: height))
        voiceView.backgroundColor = UIColor.whiteBlackColor
        backgroundView.addSubview(voiceView)
        
        let cancelButton = getCancelButton()
        voiceView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(voiceView.snp.bottom).offset(-20)
            maker.left.equalTo(voiceView.snp.left).offset(20)
        }
        
        let okButton = getOkButton()
        voiceView.addSubview(okButton)
        okButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(voiceView.snp.bottom).offset(-20)
            maker.right.equalTo(voiceView.snp.right).offset(-20)
        }
        
        textView = UITextView()
        textView.textColor = UIColor.text
        voiceView.addSubview(textView)
        textView.snp.makeConstraints { (maker) in
            maker.top.equalTo(voiceView.snp.top).offset(20)
            maker.left.equalTo(voiceView.snp.left).offset(20)
            maker.right.equalTo(voiceView.snp.right).offset(-20)
            maker.bottom.equalTo(cancelButton.snp.top).offset(-20)
        }
        
        let imageView = UIImageView()
        imageView.loadGif(name: "audiowave")
        voiceView.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(voiceView)
            maker.centerY.equalTo(cancelButton)
            maker.left.equalTo(cancelButton.snp.right).offset(15)
            maker.right.equalTo(okButton.snp.left).offset(-15)
            maker.height.equalTo(25)
        }
    }
    
    private func getCancelButton() -> UIButton {
        let cancelButton = UIButton(type: UIButton.ButtonType.custom)
        cancelButton.setImage(UIImage(named: "Cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(VoiceInputController.cancelTapped(sender:)), for: .touchUpInside)
        cancelButton.sizeToFit()
        return cancelButton
    }
    
    private func getOkButton() -> UIButton {
        let okButton = UIButton(type: UIButton.ButtonType.custom)
        okButton.setImage(UIImage(named: "Checked"), for: .normal)
        okButton.addTarget(self, action: #selector(VoiceInputController.okTapped(sender:)), for: .touchUpInside)
        okButton.sizeToFit()
        return okButton
    }
    
    @objc func cancelTapped(sender: UIButton) {
        resetRecognitionTask()
        self.dismissController()
    }
    
    @objc func okTapped(sender: UIButton) {
        resetRecognitionTask()
        if !self.textView.text.isEmpty && self.hasText {
            var thing = viewModel.saveThing(self.textView.text)
            thing.isNew = true
            delegate?.voiceInput(voiceInputView: self, thing: thing)
        }
        self.dismissController()
    }
    
    private func resetRecognitionTask() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }
    
    private func addDismissGesture() {
        // Gesture Recognizer for tapping outside the menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VoiceInputController.dismissController))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissController() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 100.0,
                       initialSpringVelocity: 0.6,
                       options: [.beginFromCurrentState, .allowUserInteraction, .overrideInheritedOptions, .curveEaseOut],
                       animations: {
                        self.view.backgroundColor = UIColor.clear
                        let origin = CGPoint(x: 0.0, y: self.view.frame.height)
                        self.backgroundView.frame = CGRect(origin: origin, size: self.backgroundView.frame.size)
        },
                       completion: {(_) in
                        self.dismiss(animated: true, completion: nil)
        })
    }
    
    // 展示此controller
    func show() {
        self.view.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.8 * 0.4,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.view.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 0.8)
        },
                       completion: nil
        )
        
        backgroundView.frame = CGRect(origin: CGPoint(x: 0.0, y: self.view.frame.height), size: backgroundView.frame.size)
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: [.beginFromCurrentState, .allowUserInteraction, .overrideInheritedOptions],
                       animations: {
                        let origin = CGPoint(x: 0.0, y: self.view.frame.height-self.backgroundView.frame.height)
                        self.backgroundView.frame = CGRect(origin: origin, size: self.backgroundView.frame.size)
                        self.backgroundView.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != gestureRecognizer.view {
            return false
        }
        return true
    }
}

extension VoiceInputController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("available")
        } else {
            print("not available")
        }
    }
}

protocol VoiceInputDelegate: NSObjectProtocol {
    func voiceInput(voiceInputView: VoiceInputController, thing: ThingModel)
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
