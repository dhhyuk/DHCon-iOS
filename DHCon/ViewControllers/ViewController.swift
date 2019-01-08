//
//  ViewController.swift
//  DHCon
//
//  Created by 김동혁 on 01/01/2019.
//  Copyright © 2019 김동혁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var constraintScrollBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var viewImageCard: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var fieldPhrases: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupNotifications()
    }
    
    private func setupViews() {
        let attributedString = NSMutableAttributedString(string: "DHCon")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 2, range: NSRange(location: 0, length: attributedString.string.count))
        self.labelTitle.attributedText = attributedString
        
        let scrollTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapScrollView))
        self.scrollView.addGestureRecognizer(scrollTapGesture)
        
        self.viewImageCard.layer.cornerRadius = 12
        self.viewImageCard.layer.shadowColor = UIColor.black.cgColor
        self.viewImageCard.layer.shadowRadius = 8
        self.viewImageCard.layer.shadowOpacity = 0.2
        self.viewImageCard.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.viewImageCard.layer.cornerRadius
        
        self.btnSelectImage.layer.cornerRadius = self.btnSelectImage.bounds.height / 2
        self.btnSelectImage.layer.shadowColor = self.btnSelectImage.backgroundColor?.cgColor
        self.btnSelectImage.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.btnSelectImage.layer.shadowOpacity = 0.4
        self.btnSelectImage.layer.shadowRadius = 8
        let btnShadowPath = UIBezierPath(roundedRect: CGRect(x: 36, y: 0, width: self.btnSelectImage.bounds.width - 72, height: self.btnSelectImage.bounds.height), cornerRadius: 16)
        self.btnSelectImage.layer.shadowPath = btnShadowPath.cgPath
        
        self.fieldPhrases.delegate = self
        
        self.btnSave.layer.cornerRadius = self.btnSave.bounds.height / 2
        self.btnSave.layer.shadowColor = self.btnSave.backgroundColor?.cgColor
        self.btnSave.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.btnSave.layer.shadowOpacity = 0.4
        self.btnSave.layer.shadowRadius = 8
        let btnSaveShadowPath = UIBezierPath(roundedRect: CGRect(x: 8, y: 0, width: self.btnSave.bounds.width - 16, height: self.btnSave.bounds.height), cornerRadius: 16)
        self.btnSave.layer.shadowPath = btnSaveShadowPath.cgPath
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let btnShadowPath = UIBezierPath(roundedRect: CGRect(x: 36, y: 0, width: self.btnSelectImage.bounds.width - 72, height: self.btnSelectImage.bounds.height), cornerRadius: 16)
        self.btnSelectImage.layer.shadowPath = btnShadowPath.cgPath
        
        let btnSaveShadowPath = UIBezierPath(roundedRect: CGRect(x: 8, y: 0, width: self.btnSave.bounds.width - 16, height: self.btnSave.bounds.height), cornerRadius: 16)
        self.btnSave.layer.shadowPath = btnSaveShadowPath.cgPath
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.fieldPhrases.isFirstResponder {
            self.fieldPhrases.resignFirstResponder()
        }
    }

    
    // MARK: - IBActions
    
    @IBAction func btnSelectImageClick(_ sender: Any) {
        guard let galleryVC = UIStoryboard(name: "Gallery", bundle: Bundle.main).instantiateInitialViewController() else {
            return
        }
        self.present(galleryVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Selectors
    
    @objc func tapScrollView() {
        if self.fieldPhrases.isFirstResponder {
            self.fieldPhrases.resignFirstResponder()
        }
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        self.constraintScrollBottomMargin.constant = isKeyboardShowing ? ((keyboardFrame?.height ?? 0) - UIApplication.shared.windows[0].safeAreaInsets.bottom) : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
