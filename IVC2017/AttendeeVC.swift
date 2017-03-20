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
	var image:UIImage?
	var storageRef:FIRStorageReference?
	var link:URL?

		override func viewDidLoad() {
			super.viewDidLoad()
			self.navB.shadowImage = UIImage()
			self.navB.setBackgroundImage(UIImage(), for: .default)
			
			self.nameLabel.defaultFont = UIFont(name: "Helvetica Neue", size:26)
			self.interestsLabel.defaultFont = UIFont(name: "Helvetica Neue", size:22)
			if let n = nameForTitle {
				nameLabel.text = n
			}
			if let i = interests {
				self.interestsLabel.text = i.uppercaseFirst
			}
			
//			self.imgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
			self.doneBut.tintColor = Utility.yellowClr
			self.interestsLabel.textColor = UIColor.white
			self.nameLabel.textColor = UIColor.white
			self.websiteButton.setTitleColor(Utility.yellowClr, for: .normal)
			self.view.backgroundColor  = Utility.redClr
			self.navB.barTintColor = Utility.purpleClr
			self.interestsLabel.lineBreakMode = .byWordWrapping
			self.interestsLabel.numberOfLines = 0
			self.doneBut.tintColor = Utility.yellowClr
			websiteButton.isHidden = true
			
			if let l = self.link {
				websiteButton.isHidden = false
				websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchDown)
			}
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
			if let i = self.image {
				self.imgView.image = i
			} else {
				self.imgView.image = UIImage(named: "user")
			}
		}
	
		@IBAction func doneTapped(_ sender: Any) {
			self.dismiss(animated: false, completion: nil)
		}

		func websiteButtonTapped(){
			if let l = link {
			if UIApplication.shared.canOpenURL(l) {
				UIApplication.shared.open(l, options: [:], completionHandler: nil)
			} else {
				webView.loadRequest(URLRequest(url: l))
				webView.delegate = self
				self.view.addSubview(webView)
			}
			}
		}

//		func getImageFromFIR(uID:String?, completion:@escaping(UIImage)->()) {
//			var image:UIImage?
//			self.storageRef = FIRStorage.storage().reference()
//		
//			let ref = storageRef?.child("images/" + "\(uID!)")
//			ref?.data(withMaxSize: 5 * 1024 * 1024, completion: { (data, err) in
//			
//			if let e = err {
//				print("Print err: \(e)")
//				Utility.displayAlertWithHandler("Error", message: "Error Downloading Images, Please Try Again Later", from: self, cusHandler: nil)
//			}
//			
//			if let d = data {
//				image = UIImage(data: d)
//				completion(image!)
//			}
//		})
//	}
	
	lazy var webView:UIWebView = {
		let a = UIWebView(frame: self.view.bounds)
		return a
	}()
}
