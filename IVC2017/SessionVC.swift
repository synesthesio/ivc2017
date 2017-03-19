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
			spkrsLab.isHidden = true
			self.colVw.isHidden = true
			if let s = speakers {
				if s.count > 0 {
					spkrsLab.isHidden = false
					self.colVw.isHidden = false
				}
			}
			self.view.backgroundColor = Utility.purpleClr
			doneBut.target = self
			doneBut.action = #selector(backTap)
			doneBut.tintColor = Utility.yellowClr
//			self.navB.tintColor = Utility.purpleClr
			self.navigationController?.navigationBar.isTranslucent = false
//			self.navB.backgroundColor = Utility.purpleClr
			self.navB.isTranslucent = false
			self.navB.barTintColor = Utility.redClr
			self.navB.layer.borderWidth = 0.5
			self.navB.layer.borderColor = Utility.yellowClr.cgColor
			
			sessionLabel.defaultFont = UIFont(name: "Helvetica Neue", size:26)
			locationLabel.defaultFont = UIFont(name: "Helvetica Neue", size:22)
			
			if let d = desc {
				descV.text = d
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
			
			
			if let img = UIImage(named: "\(nmSt.lowercased())") {
				cell.imgSpkr = UIImageView(image: img)
			} else {
				cell.imgSpkr = UIImageView(image:UIImage(named: "addPhotoPlaceholder"))
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let spkr = speakers {
		self.launchVCForSpeaker(num: indexPath.row)
		}
		print("perfunctory placeholder")
	}
	
	
}


