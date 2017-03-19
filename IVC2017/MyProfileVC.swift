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
	
	@IBOutlet weak var linktf: UITextField!
	@IBOutlet weak var nametf: UITextField!
	@IBOutlet weak var biotf: UITextField!
	var name:String?
	var titleM:String?
	var link:String?
	var firstTime:Bool = true
	var uID:String?
	var photoPicker:UIImagePickerController!
	var storageRef:FIRStorageReference!
	var profRef:FIRStorageReference!
	var imageFromPicker:UIImage?
	var downloadURL:URL?
	var takingPhoto:Bool = false
	override func viewDidLoad(){
		super.viewDidLoad()

		ref = FIRDatabase.database().reference()
		self.nametf.delegate = self
		self.linktf.delegate = self
		self.biotf.delegate = self
		self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.setupTF()
		photoPicker = UIImagePickerController()
		self.photoPicker.delegate = self
		self.navigationController?.navigationBar.isHidden = true
		let tGR = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
		tGR.delegate = self
		view.addGestureRecognizer(tGR)
		let iGR = UITapGestureRecognizer(target: self, action: #selector(imgVwTapped))
		iGR.delegate = self
		imgVw.addGestureRecognizer(iGR)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
	
		if let n = name {
			self.nametf.text = n
		}
		if let t = titleM {
			self.biotf.text = t
		}
		if let l = link {
			self.linktf.text = l
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.takingPhoto = false
		self.uID = FIRAuth.auth()?.currentUser?.uid
		
		if self.firstTime == true {
			do {
				handle = ref?.child("users").observe(.value, with: { (snapshot) in
					if snapshot.hasChild(self.uID!) {
						self.firstTime = false
					}
				})
			} catch {
				Utility.displayAlertWithHandler("Error", message: "An error occurred, please try again", from: self, cusHandler: nil)
			}
			
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.takingPhoto != true {
			self.saveButtonTapped()
		}
	}
	override func viewDidDisappear(_ animated: Bool) {
		ref?.removeAllObservers()
		super.viewDidDisappear(animated)
	}
	
	func setupTF(){
		self.nametf.font = UIFont(name: "Hevetica Neue", size: 16)
		self.biotf.font = UIFont(name: "Hevetica Neue", size: 16)
		self.linktf.font = UIFont(name: "Hevetica Neue", size: 16)
		self.nametf.textColor = UIColor.white
		self.biotf.textColor = UIColor.white
		self.linktf.textColor = UIColor.white
		self.nametf.attributedPlaceholder = NSAttributedString(string: "...", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Helvetica Neue", size:18)])
		self.biotf.attributedPlaceholder = NSAttributedString(string: "e.g. researcher", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Helvetica Neue", size:18)])
		self.linktf.attributedPlaceholder = NSAttributedString(string: "www.mysite.com", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "Helvetica Neue", size:18)])
		self.biotf.textAlignment = .center
		self.nametf.textAlignment = .center
		self.linktf.textAlignment = .center
		self.biotf.layer.borderWidth = 0.5
		self.linktf.layer.borderWidth = 0.5
		self.nametf.layer.borderWidth = 0.5
		self.biotf.layer.cornerRadius = 15.0
		self.linktf.layer.cornerRadius = 15.0
		self.nametf.layer.cornerRadius = 15.0
		self.biotf.borderStyle = .roundedRect
		self.linktf.borderStyle = .roundedRect
		self.nametf.borderStyle = .roundedRect
		self.nametf.layer.borderWidth = 0.5
		self.biotf.layer.borderWidth = 0.5
		self.linktf.layer.borderWidth = 0.5
		self.biotf.layer.borderColor = Utility.yellowClr.cgColor
		self.linktf.layer.borderColor = Utility.yellowClr.cgColor
		self.nametf.layer.borderColor = Utility.yellowClr.cgColor
		self.linktf.backgroundColor = Utility.redClr
		self.nametf.backgroundColor = Utility.redClr
		self.biotf.backgroundColor = Utility.redClr
		
	}
	
	func saveButtonTapped(){
		nametf.resignFirstResponder()
		biotf.resignFirstResponder()
		linktf.resignFirstResponder()
		if self.nametf.text != "" && self.nametf.text != nil {
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
						if let f = fSM {
							self.ref?.child("users/" + (self.uID!) + "/image").setValue(self.uID)
						}
//						guard let metadata = fSM else {
//							Utility.displayAlertWithHandler("Image Upload Error", message: "An Error Occurred During Image Upload, Please Try Again", from: self, cusHandler: nil)
//							return
//						}
//						self.downloadURL = metadata.downloadURL()
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
		  }
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
			
			linktf.resignFirstResponder()
			break
		}
		return false
	}
	
	
	func imgVwTapped(){
		self.view.endEditing(true)
		self.takingPhoto = true
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
