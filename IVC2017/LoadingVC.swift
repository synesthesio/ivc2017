//
//  LoadingVC.swift
//  IVC2017
//
//  Created by synesthesia on 3/19/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

	
	@IBOutlet var imgV:UIImageView!
	@IBOutlet var imgVForLoading:UIImageView!
	var rotate:Bool = true

    override func viewDidLoad() {
			super.viewDidLoad()
			
			self.rotateV()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func rotateV(){
		guard self.rotate else { self.dismiss(animated: false, completion: nil); return }
		UIView.animate(withDuration: 1.2, delay: 0, options: .curveLinear, animations: { 
		self.imgVForLoading.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
		self.imgVForLoading.transform = CGAffineTransform(rotationAngle: CGFloat(2.0 * M_PI))
		}) { (n) in
			self.rotateV()
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

}
