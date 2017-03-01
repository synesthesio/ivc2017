//
//  SessionVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/27/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class SessionVC: UIViewController {
	
	var titl:String!
	var speakers:[Speaker]?
	var time:String!
	var location:String?
	var address:String?
	var desc:String?
	var day:String!
	
	@IBOutlet weak var sessionLabel: UILabel!

	@IBOutlet weak var speakerButtonView: UIView!
	
	@IBOutlet weak var textVw: UITextView!
	
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
				self.sessionLabel.text = titl
				self.timeLabel.text = day + time
				self.title = titl
			if desc != nil {
				self.textVw.text = desc
			} else {
				
				if speakers != nil {
				var str = ""
					for i in speakers! {
						str.append(i.bio)
					
					}
				}
				
				
//				self.textVw.text =
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

}
