//
//  AboutVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
			
//				let url = URL(string: "http://www.iv-conference.com/faqs/")
				let url1 = URL(string:"fb://profile/215178098578794")
				let url = URL(string:"https://www.facebook.com/215178098578794/")
			
			if UIApplication.shared.canOpenURL(url1!) {
				UIApplication.shared.open(url!, options: [:], completionHandler: nil)
			} else {
				webView.loadRequest(URLRequest(url: url!))
				self.view.addSubview(webView)
			}
			
			
			
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
