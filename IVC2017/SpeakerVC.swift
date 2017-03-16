//
//  SpeakerVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit


class SpeakerVC: UIViewController,UIWebViewDelegate {
	
	var bioText:String?
	var degrees:String?
	var nameTitle:String?
	var link:URL?
	var speaker:Speaker?
	var delegate:(DismissSpeakerDelegate)!
	var session:Session!
	
	@IBOutlet weak var websiteButton: UIButton!
	
	@IBOutlet weak var imgV: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bioLabel: UILabel!
	
	
	
    override func viewDidLoad() {
			super.viewDidLoad()
			self.view.backgroundColor = Utility.redClr
			self.titleLabel.textColor = UIColor.white
			self.bioLabel.textColor = UIColor.white
			self.websiteButton.setTitleColor(Utility.yellowClr, for: .normal)
			websiteButton.isHidden = true
			if let u = link {
			websiteButton.isHidden = false
			}
			
			if let bio = bioText {
				bioLabel.textAlignment = .natural
				bioLabel.text = bio
				bioLabel.numberOfLines = 0
				bioLabel.sizeToFit()
			}
			
			if let ti = nameTitle {
				if let dg = degrees{
				self.titleLabel.text = ti + ", " + dg
				} else {
				self.titleLabel.text = ti
				}
			}
			let nmSt = nameTitle?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
			let nmStr = nmSt?.lowercased()
			if let img = UIImage(named: "\(nmStr!)") {
				self.imgV.image = img
			} else {
				self.imgV.image = UIImage(named: "addPhotoPlaceholder")
			}
			
//			let tGR = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped))
//			self.imgV.addGestureRecognizer(tGR)
    }

		override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func doneTapped(_ sender: Any) {
	self.dismiss(animated: false) { 
		self.delegate.transitionToSessioNVC(sesh: self.session)
		}
	}
	
	
	
//	func imgViewTapped(){
//		let vc = UIViewController()
//		
//		self.presen
//	}
	
	@IBAction func websiteButtonTapped(_ sender: Any) {
		if UIApplication.shared.canOpenURL(self.link!) {
			UIApplication.shared.open(self.link!, options: [:], completionHandler: nil)
		} else {
			webView.loadRequest(URLRequest(url: self.link!))
			webView.delegate = self
			self.view.addSubview(webView)
		}
	}
	
	
//	func nameButtonTapped() {
//		let wV = UIWebView(frame: self.view.bounds)
//		if let lnk = link {
//		wV.loadRequest(URLRequest(url: lnk))
//		wV.delegate = self
//		view.addSubview(wV)
//		}
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	
	lazy var webView:UIWebView = {
		let a = UIWebView(frame: self.view.bounds)
		return a
	}()

}
