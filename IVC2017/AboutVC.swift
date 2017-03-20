//
//  AboutVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

	@IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
				self.navigationController?.navigationBar.isHidden = false
			
//				let url = URL(string: "http://www.iv-conference.com/faqs/")
				let url1 = URL(string:"fb://profile/215178098578794")
				let url = URL(string:"https://www.facebook.com/215178098578794/")
			
			if UIApplication.shared.canOpenURL(url1!) {
				UIApplication.shared.open(url!, options: [:], completionHandler: nil)
			} else {
				webView.loadRequest(URLRequest(url: url!))
				self.webView.frame = self.view.bounds
				self.view.addSubview(webView)
			}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
//	lazy var webView:UIWebView = {
//		let a = UIWebView(frame: self.view.bounds)
//		a.tag = 44
//		return a
//	}()

}
