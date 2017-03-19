//
//  SessionVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/27/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class SessionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	var titl:String!
	var location:String?
	var desc:String?
	var day:String!
	var sesh:Session!
	var lastVC:EventTableVC!
	var delegate:(TransitionToSpeakerDelegate)!
	var ref:FIRDatabaseReference?
	var handle:FIRDatabaseHandle?
	var speakers:[String]?
	var time:String!
	@IBOutlet weak var spkrsLab: UILabel!
	@IBOutlet weak var colVw: UICollectionView!
	@IBOutlet weak var doneBut: UIBarButtonItem!
	@IBOutlet weak var sessionLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var navI: UINavigationItem!
	@IBOutlet weak var descV: UITextView!
	@IBOutlet weak var navB: UINavigationBar!
	
	
    override func viewDidLoad() {
			super.viewDidLoad()
			self.colVw.dataSource = self
			self.colVw.delegate = self
			ref = FIRDatabase.database().reference()
			
			self.locationLabel.isHidden = true
			self.spkrsLab.isHidden = true
			self.colVw.clipsToBounds = true
			self.colVw.isHidden = true
			self.descV.isHidden = true
			if let s = speakers {
					if s.count > 0 {
						if s[0] != "" {
						self.spkrsLab.isHidden = false
						self.colVw.isHidden = false
					}
				}
			}
			self.navB.isTranslucent = false
			self.navB.barTintColor = Utility.redClr
			self.navB.backgroundColor = Utility.redClr
			self.view.backgroundColor = Utility.redClr
			self.doneBut.target = self
			self.doneBut.action = #selector(backTap)
			self.doneBut.tintColor = Utility.yellowClr

//			self.sessionLabel.defaultFont = UIFont(name: "Helvetica Neue", size:26)
			self.sessionLabel.text = titl
//			self.locationLabel.defaultFont = UIFont(name: "Helvetica Neue", size:22)
			if let loc = self.location {
			self.locationLabel.isHidden = false
			self.locationLabel.text = loc
			}
			
			if let d = desc {
				self.descV.isHidden = false
				self.descV.text = d
			}
    }
	
	func backTap(){
		self.dismiss(animated: false, completion: nil)
	}

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	
	func launchVCForSpeaker(num:Int) {
		self.fetchSpeakerFor(name: (self.speakers?[num])!) { (spkr) in
			self.dismiss(animated: false, completion: { 
				self.delegate.transitionToSpeaker(speaker: spkr, sesh: self.sesh)
			})
		}
	}
	
	func fetchSpeakerFor(name:String, completion:@escaping(Speaker) ->()) {
		
		handle = ref?.child("speakers").child(name).observe(.value, with: { (snapshot) in
			let s = snapshot.value as! [String:AnyObject]
			let dg = s["degrees"] as! String
			let bio = s["bio"] as! String
			let ln = s["link"] as! String
			let lnk = URL(string: ln)
			let f = Speaker(dgrs: dg, bi: bio, lnk: lnk, sesh: nil, nm: name)
			completion(f)
		})
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
	
		if let spkr = speakers {
			return spkr.count
		} else {
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spkrcell", for: indexPath) as! SpeakerCVCell
		
		if let spkrs = speakers {
		
			let nmSt = spkrs[indexPath.row].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
//			let nmSt = spkrs[indexPath.row].name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
			cell.contentMode = .center
			
			if let img = UIImage(named: "\(nmSt.lowercased()).jpg") {
				cell.imgSpkr.image = img
//				img.resizeImage(size:cell.contentView.intrinsicContentSize)
				
			} else {
//				cell.contentView.addSubview(UIImageView(image:UIImage(named: "addPhotoPlaceholder")))
				cell.imgSpkr = UIImageView(image:UIImage(named: "addPhotoPlaceholder"))
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.launchVCForSpeaker(num: indexPath.row)
	}
	
}
