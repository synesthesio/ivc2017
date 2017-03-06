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


class SessionVC: UIViewController {
	
	var titl:String!
//	var speakers:[Speaker]?
	var speakers:[String]?
	var time:String!
	var location:String?
	var address:String?
	var desc:String?
	var day:String!
	var sesh:Session!
	var lastVC:EventTableVC!
	var delegate:(TransitionToSpeakerDelegate)!
	var ref:FIRDatabaseReference?
	var handle:FIRDatabaseHandle?
	@IBOutlet weak var doneBut: UIBarButtonItem!
	@IBOutlet weak var sessionLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var addrLabel: UILabel!
	@IBOutlet weak var b1: UIButton!
	@IBOutlet weak var b2: UIButton!
	@IBOutlet weak var b3: UIButton!
	@IBOutlet weak var b4: UIButton!
	@IBOutlet weak var b5: UIButton!
	@IBOutlet weak var b6: UIButton!
	@IBOutlet weak var b7: UIButton!
	
	
	
    override func viewDidLoad() {
			super.viewDidLoad()
			ref = FIRDatabase.database().reference()
			doneBut.target = self
			doneBut.action = #selector(backTap)
//				self.tabBarController?.navigationController?.navigationBar.isHidden = false
			b1.isHidden = true
			b2.isHidden = true
			b3.isHidden = true
			b4.isHidden = true
			b5.isHidden = true
			b6.isHidden = true
			b7.isHidden = true
			
			if let spkr = speakers {
				for i in 0..<spkr.count {
//					let a = spkr[i]
					switch i {
					case 0:
						b1.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						break
					case 1:
						b1.isHidden = false
						b2.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b2.setTitle(spkr[1], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						b2.addTarget(self, action: #selector(btap2), for: .touchDown)
						break
					case 2:
						b1.isHidden = false
						b2.isHidden = false
						b3.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b2.setTitle(spkr[1], for: .normal)
						b3.setTitle(spkr[2], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						b2.addTarget(self, action: #selector(btap2), for: .touchDown)
						b3.addTarget(self, action: #selector(btap3), for: .touchDown)
						break
					case 3:
						b1.isHidden = false
						b2.isHidden = false
						b3.isHidden = false
						b4.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b2.setTitle(spkr[1], for: .normal)
						b3.setTitle(spkr[2], for: .normal)
						b4.setTitle(spkr[3], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						b2.addTarget(self, action: #selector(btap2), for: .touchDown)
						b3.addTarget(self, action: #selector(btap3), for: .touchDown)
						b4.addTarget(self, action: #selector(btap4), for: .touchDown)
						break
					case 4:
						b1.isHidden = false
						b2.isHidden = false
						b3.isHidden = false
						b4.isHidden = false
						b5.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b2.setTitle(spkr[1], for: .normal)
						b3.setTitle(spkr[2], for: .normal)
						b4.setTitle(spkr[3], for: .normal)
						b5.setTitle(spkr[4], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						b2.addTarget(self, action: #selector(btap2), for: .touchDown)
						b3.addTarget(self, action: #selector(btap3), for: .touchDown)
						b4.addTarget(self, action: #selector(btap4), for: .touchDown)
						b5.addTarget(self, action: #selector(btap5), for: .touchDown)
						break
					case 5:
						b1.isHidden = false
						b2.isHidden = false
						b3.isHidden = false
						b4.isHidden = false
						b5.isHidden = false
						b6.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b2.setTitle(spkr[1], for: .normal)
						b3.setTitle(spkr[2], for: .normal)
						b4.setTitle(spkr[3], for: .normal)
						b5.setTitle(spkr[4], for: .normal)
						b6.setTitle(spkr[5], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						b2.addTarget(self, action: #selector(btap2), for: .touchDown)
						b3.addTarget(self, action: #selector(btap3), for: .touchDown)
						b4.addTarget(self, action: #selector(btap4), for: .touchDown)
						b5.addTarget(self, action: #selector(btap5), for: .touchDown)
						b6.addTarget(self, action: #selector(btap6), for: .touchDown)
						break
					case 6:
						b1.isHidden = false
						b2.isHidden = false
						b3.isHidden = false
						b4.isHidden = false
						b5.isHidden = false
						b6.isHidden = false
						b7.isHidden = false
						b1.setTitle(spkr[0], for: .normal)
						b2.setTitle(spkr[1], for: .normal)
						b3.setTitle(spkr[2], for: .normal)
						b4.setTitle(spkr[3], for: .normal)
						b5.setTitle(spkr[4], for: .normal)
						b6.setTitle(spkr[5], for: .normal)
						b7.setTitle(spkr[6], for: .normal)
						b1.addTarget(self, action: #selector(btap1), for: .touchDown)
						b2.addTarget(self, action: #selector(btap2), for: .touchDown)
						b3.addTarget(self, action: #selector(btap3), for: .touchDown)
						b4.addTarget(self, action: #selector(btap4), for: .touchDown)
						b5.addTarget(self, action: #selector(btap5), for: .touchDown)
						b6.addTarget(self, action: #selector(btap6), for: .touchDown)
						b7.addTarget(self, action: #selector(btap7), for: .touchDown)
//						b1.
//						b2.
//						b3.
//						b4.
//						b5.
//						b6.
//						b7.
						break
					default:
						print("perfunctory placeholder")
						break
					}
				}
			}
				self.sessionLabel.text = titl
				self.timeLabel.text = day +  (", ") + time
				self.sessionLabel.textAlignment = .center
				self.sessionLabel.adjustsFontSizeToFitWidth = true
			
//				var buttons:[UIButton] = []
			
			if desc != nil {
				self.descLabel.isHidden = false
				self.descLabel.numberOfLines = 0
				self.descLabel.textAlignment = .natural
				self.descLabel.sizeToFit()

				self.descLabel.text = desc
			}
    }
	
	func backTap(){
		self.dismiss(animated: false, completion: nil)
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func btap1(){
		launchVCForSpeaker(num: 0)
	}
	func btap2(){
		launchVCForSpeaker(num: 1)
	}
	func btap3(){
		launchVCForSpeaker(num: 2)
	}
	func btap4(){
		launchVCForSpeaker(num: 3)
	}
	func btap5(){
		launchVCForSpeaker(num: 4)
	}
	func btap6(){
		launchVCForSpeaker(num: 5)
	}
	func btap7(){
		launchVCForSpeaker(num: 6)
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
	
	
	
	
	
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//	
//		if let spkr = speakers {
//			return spkr.count
//		} else {
//			return 0
//		}
//	}
	
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as! IndexPath) as! UICollectionViewCell
//		if let spkrs = speakers {
//			let nmSt = spkrs[indexPath.row].name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
//			
//			if let img = UIImage(named: "\(nmSt.lowercased())") {
//				cell.backgroundView = UIImageView(image: img)
//			} else {
//				cell.backgroundView = UIImageView(image:UIImage(named: "addPhotoPlaceholder"))
//			}
//		}
//		return cell
//	}
	
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		if let spkr = speakers {
//		let a = spkr[indexPath.row] as! Speaker
//		
//			let vc = self.storyboard?.instantiateViewController(withIdentifier: "speakervc") as! SpeakerVC
//			vc.bioText = a.bio
//			vc.degrees = a.degrees
//			vc.nameTitle = a.name + (", ") + a.degrees
//			vc.link = a.link
//			self.navigationController?.pushViewController(vc, animated: false)
//		}
//		print("perfunctory placeholder")
//	}
}


