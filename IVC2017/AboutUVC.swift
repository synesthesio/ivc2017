//
//  AboutUVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/28/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
class AboutUVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
	
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	weak var constraintKeyboardHeight:NSLayoutConstraint!
	
	override func viewDidLoad(){
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		//		self.navigationItem.rightBarButtonItem =
		//		self.navigationItem.leftBarButtonItem =
		constraintKeyboardHeight = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
		constraintKeyboardHeight.isActive = true
		view.addConstraint(constraintKeyboardHeight)
		tf.delegate = self
		let tGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
		tGR.delegate = self
		view.addGestureRecognizer(tGR)
		view.addSubview(tf)
		view.addSubview(lazyButton)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//set first responder
		tf.becomeFirstResponder()
	}
	
	override func updateViewConstraints() {
		NSLayoutConstraint(item: tf, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: tf, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: lazyButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
		NSLayoutConstraint(item: lazyButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 100).isActive = true
		//add & set all constraints to active above super.updateViewConstraints()
		super.updateViewConstraints()
	}
	
	func screenTapped(){
		self.view.endEditing(true)
		tf.resignFirstResponder()
		//call resignFirstResponder on all text fields
	}
	
	lazy var tf:UITextField! = {
		let v = UITextField()
		v.translatesAutoresizingMaskIntoConstraints = false
		v.borderStyle = .roundedRect
		v.layer.cornerRadius = 5
		v.layer.borderWidth = 3
		v.layer.borderColor = UIColor.white.cgColor
		v.textAlignment = .center
		v.attributedPlaceholder = NSAttributedString(string: "PLACEHOLDER", attributes: [ NSForegroundColorAttributeName: UIColor.black ])
		return v
	}()
	
	func keyboardWillShow(_ sender: Notification) {
		if let f = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
			let newF = self.view.convert(f, from: (UIApplication.shared.delegate?.window)!)
			constraintKeyboardHeight.constant = newF.origin.y - self.view.frame.height
		}
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
	
	func keyboardWillHide(_ sender: Notification) {
		constraintKeyboardHeight.constant = 0
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		switch textField {
		case tf:
			tf.clearsOnBeginEditing = true
		default:
			//
			break
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case tf:
			//make next textField becomeFirstResponder
			break
		default:
			//
			break
		}
		return false
	}
	
	lazy var lazyButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.addTarget(self, action: #selector(lazyButtonTapped), for:UIControlEvents.touchDown)
		b.layer.opacity = 0.25
		b.setTitle("Save", for: .normal)
		return b
	}()
	
	func lazyButtonTapped(){
		
		ref = FIRDatabase.database().reference()
		handle = ref?.child("users"). 
		
	}
}
