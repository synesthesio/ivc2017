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

class AboutUVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate{
	
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	weak var constraintKeyboardHeight:NSLayoutConstraint!
	@IBOutlet weak var imgVw: UIImageView!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBOutlet weak var linktf: UITextField!
	@IBOutlet weak var nametf: UITextField!
	@IBOutlet weak var biotf: UITextField!
	
	var photoPicker:UIImagePickerController!
	
	
	override func viewDidLoad(){
		super.viewDidLoad()
		photoPicker = UIImagePickerController()
		self.photoPicker.delegate = self
		self.navigationController?.navigationBar.isHidden = true
		imgVw.contentMode = .scaleAspectFit

		constraintKeyboardHeight = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
		constraintKeyboardHeight.isActive = true
		view.addConstraint(constraintKeyboardHeight)
//		tf.delegate = self
		let tGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
		tGR.delegate = self
		view.addGestureRecognizer(tGR)
		let iGR = UITapGestureRecognizer(target: self, action: #selector(imgVwTapped))
		iGR.delegate = self
		imgVw.addGestureRecognizer(iGR)
//		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchDown)
//		saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(lazyButtonTapped))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//set first responder
//		tf.becomeFirstResponder()
	}
	override func viewDidDisappear(_ animated: Bool) {
		ref?.removeAllObservers()
		super.viewDidDisappear(animated)
	}
	
//	override func updateViewConstraints() {
//		NSLayoutConstraint(item: tf, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//		NSLayoutConstraint(item: tf, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//		NSLayoutConstraint(item: lazyButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//		NSLayoutConstraint(item: lazyButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 100).isActive = true
//		//add & set all constraints to active above super.updateViewConstraints()
//		super.updateViewConstraints()
//	}
	
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
		case nametf:
			nametf.clearsOnBeginEditing = true
		case biotf:
			biotf.clearsOnBeginEditing = true
		default:
			linktf.clearsOnBeginEditing = true
			break
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		ref = FIRDatabase.database().reference()
	
	
		if UserDefaults.standard.value(forKey: "uid") == nil {
		let str = String(describing: arc4random())
		UserDefaults.standard.set(str, forKey: "uid")
		
			switch textField {
			case nametf:
				if let name = nametf.text {
					ref?.child("users").child(str).setValue(["name":name])
				} else {
					Utility.displayAlertWithHandler("Please Enter Name", message: "Please Enter a Name", from: self, cusHandler: nil)
				}
				break
		  case biotf:
				if let bio = biotf.text {
					ref?.child("users").child(str).setValue(["bio":bio])
				}
				break
			default:
				if let link = linktf.text {
					ref?.child("users").child(str).setValue(["link":link])
				}
				break
			}
			
		} else {
			
			let st = UserDefaults.standard.value(forKey: "uid")
			switch textField {
			
			case nametf:
				if let name = nametf.text {
					ref?.child("users/(st)/name").setValue(name)
				}
			case biotf:
				if let bio = biotf.text {
					ref?.child("users/(st)/bio").setValue(bio)
				}
			default:
				if let link = linktf.text {
					ref?.child("users/(st)/link").setValue(link)
				}
			}
		}
	
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case nametf:
			linktf.becomeFirstResponder()
		case biotf:
			linktf.becomeFirstResponder()
			//make next textField becomeFirstResponder
			break
		default:
			//
			break
		}
		return false
	}
	
	
	func imgVwTapped(){
	let ac = UIAlertController(title: "Take a Photo?", message: "Take a photo or select from Camera Roll", preferredStyle: .actionSheet)
	let photoAct = UIAlertAction(title: "Use Camera", style: .default) { (photo) in
		self.photoPicker.allowsEditing = true
		self.photoPicker.sourceType = .camera
		}
	ac.addAction(photoAct)
	let libAct = UIAlertAction(title: "Use Photo Library", style: .default) { (lib) in
		print("perfunctory placeholder")
		self.photoPicker.sourceType = .photoLibrary
		}
	ac.addAction(libAct)
	let rollAct = UIAlertAction(title: "Use Camera Roll", style: .default) { (roll) in
		self.photoPicker.sourceType = .savedPhotosAlbum
		}
  ac.addAction(rollAct)
		self.present(self.photoPicker, animated: false, completion: {
			print("perfunctory placeholder")
		})
	}
	
	func screenTapped(){
		self.view.endEditing(true)
//		tf.resignFirstResponder()
		//call resignFirstResponder on all text fields
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let picked = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.imgVw.image = picked
		}
		self.dismiss(animated: false) {
		print("perfunctory placeholder")
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: false) { 
			print("perfunctory placeholder")
		}
	}
	
}