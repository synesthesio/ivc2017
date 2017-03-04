//
//  AttendeeVC.swift
//  IVC2017
//
//  Created by synesthesia on 3/3/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//
import Foundation
import UIKit



class AttendeeVC: UIViewController,UIWebViewDelegate {

	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var interestsLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var websiteButton: UIButton!
	var nameForTitle:String?
	var interests:String?
	var image:UIImage?
	var link:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
			
			websiteButton.isHidden = true
			if let u = self.link {
						websiteButton.isHidden = false
				websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchDown)
			}
			
			if let img = image {
				self.imgView.image = img
			}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
