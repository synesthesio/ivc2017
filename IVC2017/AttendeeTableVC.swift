//
//  AttendeeTableVC.swift
//  IVC2017
//
//  Created by synesthesia on 2/26/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class AttendeeTableVC: UICollectionViewController {

	
	@IBOutlet var colV: UICollectionView!
//	var aImages:[UIImage] = []
//	var handle:FIRDatabaseHandle?
//	var ref:FIRDatabaseReference?
	var attendees:[Attendee]?
//	var storageRef:FIRStorageReference?
//	var loadingVC:LoadingVC!
//	var loaded:Bool = false
//	var goingToLoading:Bool = false
//	
    override func viewDidLoad() {
        super.viewDidLoad()
				self.colV.dataSource = self
				self.colV.delegate = self
			if Utility.attendees.count > 0 {
				self.attendees = Utility.attendees
				}
				self.title = "Attendees"
				self.view.backgroundColor = Utility.redClr
			
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
//		if !goingToLoading {
//		self.loaded = false
//		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		if !self.loaded {
//		self.goingToLoading = true
//		self.loadingVC = self.storyboard?.instantiateViewController(withIdentifier: "loading") as! LoadingVC
//		self.present(self.loadingVC, animated: false, completion: nil)
//		}
//		self.fetchAttendees(completion: { (att) in
//			self.attendees = att
//			self.fetchUserImages()
//		})
		}
	
	
//	func fetchUserImages(){
//		
//		if let at = self.attendees {
//			for i in at {
//				if let id = i.uID{
//				
//					self.getImageFromFIR(uID: id, completion: { (img) in
//						self.aImages.append(img)
//						self.loadingVC.rotate = false
//						self.loaded = true
//						self.goingToLoading = false
//						self.colV.reloadData()
//					})
//				}
//			}
//		}
//	}
	
	
	
	
//	func getImageFromFIR(uID:String?, completion:@escaping(UIImage)->()) {
//		var image:UIImage?
//		self.storageRef = FIRStorage.storage().reference()
//		
//		let ref = storageRef?.child("images/" + "\(uID!)")
//		ref?.data(withMaxSize: 5 * 1024 * 1024, completion: { (data, err) in
//			
//			if let e = err {
//				print("Print err: \(e)")
//				Utility.displayAlertWithHandler("Error", message: "Error Downloading Images, Please Try Again Later", from: self, cusHandler: nil)
//			}
//			
//			if let d = data {
//				image = UIImage(data: d)
//				completion(image!)
//			}
//		})
//	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		var ct = 0
		if let att = attendees {
			ct = att.count
		}
		return ct
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	
				if let att = self.attendees {
					let attendee = att[indexPath.row]
					let vc = self.storyboard?.instantiateViewController(withIdentifier: "attendeevc") as! AttendeeVC
					vc.interests = attendee.bio
					vc.nameForTitle = attendee.name
					vc.link = attendee.link
					vc.uID = attendee.uID
					self.tabBarController?.present(vc, animated: false, completion: nil)
				} else {
					
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "atcell", for: indexPath) as! AttendeeCVCell
		  if let at = self.attendees {
				
				if let img = at[indexPath.row].image {
					if let i = img.resizeImage(size: CGSize(width: 80, height: 80)) {
						cell.img.image = i
					} else {
						cell.img.image = UIImage(named: "user")
					}
				} else {
					cell.img.image = UIImage(named: "user")
				}
		}
		return cell
	}

}

