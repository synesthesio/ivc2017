//
//  TabBarVC.swift
//  IVC2017
//
//  Created by synesthesia on 3/13/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
				self.tabBar.barTintColor = Utility.purpleClr
//				self.tabBar.delegate = self
				let profileImg = #imageLiteral(resourceName: "user")
				let attendees = #imageLiteral(resourceName: "users")
				let cal = #imageLiteral(resourceName: "cal")
				let info = #imageLiteral(resourceName: "info")
				let leaf = #imageLiteral(resourceName: "leaf")
				let images = [cal,leaf,attendees,info,profileImg]
//				self.tabBar.backgroundColor = Utility.purpleClr
			if let tI = self.tabBar.items {
				for i in 0..<tI.count {
					let item = tI[i]
					item.image = images[i].withRenderingMode(.alwaysOriginal)
					item.selectedImage = images[i]
				}
			}
		
			self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
			
			
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
