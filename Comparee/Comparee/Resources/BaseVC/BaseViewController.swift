//
//  BaseViewController.swift
//  DEO Video
//
//  Created by Oleg Home on 06.11.2020.
//

import UIKit

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    var loadingIndicator: UIActivityIndicatorView?
    var isObservingKeyboard: Bool { false }
    
    private let notificationCenter = NotificationCenter.default
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardDidShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?
    private(set) var keyboardFrame: CGRect = .zero
    private(set) var keyboardAnimationDuration: TimeInterval = 0.25
    private(set) var keyboardAppeared = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .default }
    var loadingIndicatorColor: UIColor { .black }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObservers()
    }
}

// MARK: - Common methods
extension BaseViewController {
    @objc func keyboardWillShowAction() { }
    @objc func keyboardDidShowAction() { }
    @objc func keyboardWillHideAction() { }
}

private extension BaseViewController {
    func addObservers() {
        guard isObservingKeyboard else { return }
        
        keyboardDidShowObserver = notificationCenter.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main, using: { [weak self] (notification) in
            self?.keyboardDidShowAction()
        })
        keyboardWillShowObserver = notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] (notification) in
            if self?.keyboardAppeared ?? true { return }
            
            self?.keyboardAppeared = true
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                self?.keyboardFrame = keyboardFrame.cgRectValue
            }
            
            if let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                self?.keyboardAnimationDuration = keyboardAnimationDuration
            }
            self?.keyboardWillShowAction()
        })
        keyboardWillHideObserver = notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] (notification) in
            if !(self?.keyboardAppeared ?? true) { return }
            
            self?.keyboardAppeared = false
            self?.keyboardWillHideAction()
        })
    }
    
    func removeObservers() {
        guard isObservingKeyboard else { return }
        
        if keyboardWillShowObserver != nil {
            notificationCenter.removeObserver(keyboardWillShowObserver!)
        }
        if keyboardDidShowObserver != nil {
            notificationCenter.removeObserver(keyboardDidShowObserver!)
        }
        if keyboardWillHideObserver != nil {
            notificationCenter.removeObserver(keyboardWillHideObserver!)
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}
