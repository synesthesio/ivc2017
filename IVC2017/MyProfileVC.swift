//
//  AboutUVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/28/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MyProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate{
	
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	@IBOutlet weak var imgVw: UIImageView!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var linktf: UITextField!
	@IBOutlet weak var nametf: UITextField!
	@IBOutlet weak var biotf: UITextField!
	
	var firstTime:Bool = true
	var uID:String?
	var photoPicker:UIImagePickerController!
	var storageRef:FIRStorageReference!
	var profRef:FIRStorageReference!
	var imageFromPicker:UIImage?
	var downloadURL:URL?
	override func viewDidLoad(){
		super.viewDidLoad()
//		FIRDatabase.database().persistenceEnabled = true
		ref = FIRDatabase.database().reference()
		
		
		
		photoPicker = UIImagePickerController()
		self.photoPicker.delegate = self
		self.navigationController?.navigationBar.isHidden = true
//		imgVw.contentMode = .scaleAspectFit
//		tf.delegate = self
		let tGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
		tGR.delegate = self
		view.addGestureRecognizer(tGR)
		let iGR = UITapGestureRecognizer(target: self, action: #selector(imgVwTapped))
		iGR.delegate = self
		imgVw.addGestureRecognizer(iGR)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchDown)
//		saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(lazyButtonTapped))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.uID = FIRAuth.auth()?.currentUser?.uid
		
		if self.firstTime == true {
			handle = ref?.child("users").observe(.value, with: { (snapshot) in
				if snapshot.hasChild(self.uID!) {
					self.firstTime = false
				}
			})
		}
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
	
	
	
	
	
	func saveButtonTapped(){
		nametf.resignFirstResponder()
		biotf.resignFirstResponder()
		linktf.resignFirstResponder()

			if let n = self.nametf.text {
				self.ref?.child("users/" + (self.uID!) + "/name").setValue(n)
			} else {
				Utility.displayAlertWithHandler("Please Enter Info", message: "Please provide a name to proceed", from: self, cusHandler: nil)
		}
			if let l = self.linktf.text {
				self.ref?.child("users/" + (self.uID!) + "/link").setValue(l)
			}
			
			if let b = self.biotf.text {
				self.ref?.child("users/" + (self.uID!) + "/bio").setValue(b)
			}
		
		  if let img = self.imageFromPicker {
			
				self.storageRef =  FIRStorage.storage().reference()
				let imgRef = storageRef.child("images")
				if let u = self.uID {
					profRef = imgRef.child(u)
					let meta = FIRStorageMetadata()
					meta.contentType = "image/jpeg"
					
					let upload = profRef.put(UIImageJPEGRepresentation(img, 0.75)!, metadata: meta, completion: { (fSM, err) in
						if let e = err {
							print("Print error = : \(e)")
							Utility.displayAlertWithHandler("Image Upload Error", message: "An Error Occurred During Image Upload, Please Try Again", from: self, cusHandler: nil)
						}
						guard let metadata = fSM else {
							Utility.displayAlertWithHandler("Image Upload Error", message: "An Error Occurred During Image Upload, Please Try Again", from: self, cusHandler: nil)
							return
						}
//						self.downloadURL = metadata.downloadURL()
						self.ref?.child("users/" + (self.uID!) + "/image").setValue(self.profRef)
//						self.ref?.child("users/" + (self.uID!) + "/image").setValue(self.downloadURL)
					})
					upload.observe(.failure, handler: { (snapshot) in
						if let error = snapshot.error as? NSError {
							switch (FIRStorageErrorCode(rawValue: error.code)!) {
							case .objectNotFound:
								// File doesn't exist
								break
							case .unauthorized:
								// User doesn't have permission to access file
								break
							case .cancelled:
								// User canceled the upload
								break
								
								/* ... */
								
							case .unknown:
								// Unknown error occurred, inspect the server response
								break
							default:
								// A separate error occurred. This is a good place to retry the upload.
								break
							}
						}

					})
				upload.observe(.success, handler: { (snapshot) in
					print("perfunctory placeholder")
				})
				}
			
			
			
			
			
			
//				self.ref?.child("users/" + (self.uID!) + "/image").setValue(img)
		  }

	}
	
	func keyboardWillShow(_ sender: Notification) {
		
		if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	func keyboardWillHide(_ sender: Notification) {
		if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
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
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case nametf:
			biotf.becomeFirstResponder()
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
		self.view.endEditing(true)
		let ac = UIAlertController(title: "Take a Photo?", message: "Take a photo or select from Camera Roll", preferredStyle: .actionSheet)
		let photoAct = UIAlertAction(title: "Use Camera", style: .default) { (photo) in
		self.photoPicker.allowsEditing = true
		self.photoPicker.sourceType = .camera
		self.present(self.photoPicker, animated: false, completion: nil)
		}
		ac.addAction(photoAct)
		let libAct = UIAlertAction(title: "Use Photo Library", style: .default) { (lib) in
		print("perfunctory placeholder")
		self.photoPicker.sourceType = .photoLibrary
		self.present(self.photoPicker, animated: false, completion: nil)
		}
		ac.addAction(libAct)
//		let rollAct = UIAlertAction(title: "Use Camera Roll", style: .default) { (roll) in
//		self.photoPicker.sourceType = .savedPhotosAlbum
//		self.present(self.photoPicker, animated: false, completion: nil)
//		}
//		ac.addAction(rollAct)
		self.present(ac, animated: false, completion: {
			print("perfunctory placeholder")
		})
		let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (cancel) in
			self.dismiss(animated: false, completion: nil)
		}
		ac.addAction(cancel)
	}
	
	func screenTapped(){
		self.view.endEditing(true)
//		tf.resignFirstResponder()
		//call resignFirstResponder on all text fields
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let picked = info[UIImagePickerControllerOriginalImage] as? UIImage {
		self.imageFromPicker = picked
		
			self.imgVw.image = self.imageFromPicker
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
