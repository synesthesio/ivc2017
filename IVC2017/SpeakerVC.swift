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
    override func viewDidLoad() {
        super.viewDidLoad()
			if let bio = bioText {
				textDisplay.text = bio
			}
//			if let nT = nameTitle {
//				
//			}
			if let dg = degrees {
			  degreeLabel.text = dg
			}
//			if let img = UIImage(named: <#T##String#>)
			
//			self.view.addSubview(<#T##view: UIView##UIView#>)
			self.view.addSubview(degreeLabel)
			self.view.addSubview(imgView)
			self.view.addSubview(textDisplay)
			self.view.addSubview(nameButton)
        // Do any additional setup after loading the view.
    }

		override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
		override func updateViewConstraints() {
//		NSLayoutConstraint(item: <#T##Any#>, attribute: <#T##NSLayoutAttribute#>, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
			NSLayoutConstraint(item: nameButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0, constant: 0).isActive = true
			
		//add all above
		super.updateViewConstraints()
		}
	
	func nameButtonTapped() {
		let wV = UIWebView(frame: self.view.bounds)
		if let lnk = link {
		wV.loadRequest(URLRequest(url: lnk))
		wV.delegate = self
		view.addSubview(wV)
		}
		
//		self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//		wv.ur
//		self.view =
	}
	
	lazy var textDisplay:UITextView = {
		let a = UITextView()
		a.translatesAutoresizingMaskIntoConstraints = false
		a.textAlignment = .left
		return a
	}()
	
	lazy var nameButton:UIButton! = {
		let b = UIButton()
		b.translatesAutoresizingMaskIntoConstraints = false
		b.addTarget(self, action: #selector(nameButtonTapped), for:UIControlEvents.touchDown)
		b.layer.opacity = 0.75
		b.setTitle(self.nameTitle, for: .normal)
		return b
	}()
	
	lazy var degreeLabel:UILabel! = {
		let d = UILabel()
		d.translatesAutoresizingMaskIntoConstraints = false
		return d
	}()
	
	lazy var imgView:UIImageView = {
	
		let c = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width/2, height: self.view.bounds.height/4))
		c.translatesAutoresizingMaskIntoConstraints = false
		return c
	}()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	

}
