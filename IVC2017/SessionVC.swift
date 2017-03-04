//
//  SessionVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/27/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit

class SessionVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
	
	var titl:String!
	var speakers:[Speaker]?
	var time:String!
	var location:String?
	var address:String?
	var desc:String?
	var day:String!
	
	@IBOutlet weak var sessionLabel: UILabel!	
	
	@IBOutlet weak var descLabel: UILabel!
	
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var locationLabel: UILabel!
	
	@IBOutlet weak var collView: UICollectionView!
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
				self.sessionLabel.text = titl
				self.timeLabel.text = day +  (", ") + time
				self.sessionLabel.textAlignment = .center
				self.sessionLabel.adjustsFontSizeToFitWidth = true
			
//				var buttons:[UIButton] = []
			
			if desc != nil {
				self.descLabel.numberOfLines = 0
				self.descLabel.textAlignment = .natural
				self.descLabel.sizeToFit()

				self.descLabel.text = desc
			} else {
				
				if let spkrs = speakers {
				
					for i in 0..<spkrs.count {
					let spkr = spkrs[i]
					let button = UIButton(type: .custom)
					button.titleLabel?.text = spkr.name + spkr.degrees
//				  buttons.append(button)
					}
				}
				
//				for i in 0..<buttons.count {
				
//				}
				
				
//				self.textVw.text =
			}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
	
		if let spkr = speakers {
			return spkr.count
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as! IndexPath) as! UICollectionViewCell
		if let spkrs = speakers {
			let nmSt = spkrs[indexPath.row].name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
			
			if let img = UIImage(named: "\(nmSt.lowercased())") {
				cell.backgroundView = UIImageView(image: img)
			} else {
				cell.backgroundView = UIImageView(image:UIImage(named: "addPhotoPlaceholder"))
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let spkr = speakers {
		let a = spkr[indexPath.row] as! Speaker
		
			let vc = self.storyboard?.instantiateViewController(withIdentifier: "speakervc") as! SpeakerVC
			vc.bioText = a.bio
			vc.degrees = a.degrees
			vc.nameTitle = a.name + (", ") + a.degrees
			vc.link = a.link
			self.navigationController?.pushViewController(vc, animated: false)
		}
		print("perfunctory placeholder")
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
