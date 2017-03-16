//
//  AttendeeVC.swift
//  IVC2017
//
//  Created by synesthesia on 3/3/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//
import Foundation
import UIKit
import Firebase


class AttendeeVC: UIViewController,UIWebViewDelegate {

	@IBOutlet weak var doneBut: UIBarButtonItem!
	@IBOutlet weak var navB: UINavigationBar!
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var interestsLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var websiteButton: UIButton!
	var nameForTitle:String?
	var interests:String?
	var uID:String?
	var storageRef:FIRStorageReference?
	var link:URL?

		override func viewDidLoad() {
			super.viewDidLoad()
//			self.title = nameForTitle
			
//			self.imgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
			self.doneBut.tintColor = Utility.yellowClr
			self.interestsLabel.textColor = UIColor.white
			self.nameLabel.textColor = UIColor.white
			self.websiteButton.setTitleColor(Utility.yellowClr, for: .normal)
			self.view.backgroundColor  = Utility.redClr
			self.navB.barTintColor = Utility.purpleClr
			self.interestsLabel.lineBreakMode = .byWordWrapping
			self.interestsLabel.numberOfLines = 0
			
			websiteButton.isHidden = true
			
						websiteButton.isHidden = false
				websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchDown)
			
		}

		override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		}
	
	override func updateViewConstraints() {
		NSLayoutConstraint(item: self.imgView, attribute: .top, relatedBy: .equal, toItem: self.navB, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
		NSLayoutConstraint(item: self.imgView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
		NSLayoutConstraint(item: self.imgView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
		
		//add all above
		super.updateViewConstraints()
	}
	
		override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)

			if let id = self.uID {
			self.getImageFromFIR(uID: id, completion: { (img) in
				self.imgView.image = img
				})
			}
		}
	
		@IBAction func doneTapped(_ sender: Any) {
			self.dismiss(animated: false, completion: nil)
		}

		func websiteButtonTapped(){
			if UIApplication.shared.canOpenURL(self.link!) {
				UIApplication.shared.open(self.link!, options: [:], completionHandler: nil)
			} else {
				webView.loadRequest(URLRequest(url: self.link!))
				webView.delegate = self
				self.view.addSubview(webView)
			}
		}

		func getImageFromFIR(uID:String?, completion:@escaping(UIImage)->()) {
			var image:UIImage?
			self.storageRef = FIRStorage.storage().reference()
		
			let ref = storageRef?.child("images/" + "\(uID!)")
			ref?.data(withMaxSize: 5 * 1024 * 1024, completion: { (data, err) in
			
			if let e = err {
				print("Print err: \(e)")
				Utility.displayAlertWithHandler("Error", message: "Error Downloading Images, Please Try Again Later", from: self, cusHandler: nil)
			}
			
			if let d = data {
				image = UIImage(data: d)
				completion(image!)
			}
			
		})
	}
	
	lazy var webView:UIWebView = {
		let a = UIWebView(frame: self.view.bounds)
		return a
	}()
}
