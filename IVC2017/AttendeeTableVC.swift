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
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	var attendees:[Attendee]?
	var storageRef:FIRStorageReference?
	var loadingVC:LoadingVC!
	var loaded:Bool = false
	var myGrp = DispatchGroup()
	var goingToLoading:Bool = false
//
    override func viewDidLoad() {
        super.viewDidLoad()
				self.colV.dataSource = self
				self.colV.delegate = self
//			if Utility.attendees.count > 0 {
//				self.attendees = Utility.attendees
//				}
				self.title = "Attendees"
				self.view.backgroundColor = Utility.redClr
			
    }

	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let h = self.handle {
			self.ref?.removeObserver(withHandle: h)
		} else {
			self.ref?.removeAllObservers()
		}
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if !goingToLoading {
			self.loaded = false
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if !self.loaded {
			self.goingToLoading = true
			self.loadingVC = self.storyboard?.instantiateViewController(withIdentifier: "loading") as! LoadingVC
			self.present(self.loadingVC, animated: false, completion: nil)
			self.fetchAttendees { (atte) in
				self.attendees = atte
				if let a = self.attendees {
					self.fetchImagesForAttendees(att: a, completion: { (attend) in
//						Utility.attendees = attend
						self.attendees = attend
						self.loaded = true
						self.loadingVC.rotate = false
						self.goingToLoading = false
						self.colV.reloadData()
					})
				}
			}
		}
	}
	
	
	func fetchImagesForAttendees(att:[Attendee], completion:@escaping([Attendee])->()){
		var array:[Attendee] = []
		self.storageRef = FIRStorage.storage().reference()
		
		for x in att {
			self.myGrp.enter()
			var a = x
			guard let id = a.uID else { break }
			
			self.getImageFromFIR(uID: id, completion: { (img) in
				
				if let im = img {
					a.image = im
					array.append(a)
				}
				self.myGrp.leave()
			})
			//			array.append(a)
		}
		myGrp.notify(queue: DispatchQueue.main) {
			completion(array)
		}
	}
	
	func getImageFromFIR(uID:String, completion:@escaping(UIImage?)->()) {
		var image:UIImage?
		self.storageRef = FIRStorage.storage().reference()
		let ref1 = storageRef?.child("images/" + "\(uID)")
		do {
			ref1?.data(withMaxSize: 5 * 1024 * 1024, completion: { (data, err) in
				if let e = err {
					print("Print err: \(e)")
					Utility.displayAlertWithHandler("Error", message: "Error Downloading Images, Please Try Again Later", from: self, cusHandler: nil)
				}
				
				if let d = data {
					if let image = UIImage(data: d) {
						completion(image)
					}
				}
			})
		} catch {
			Utility.displayAlertWithHandler("Error", message: "Error Downloading Images, Please Try Again Later", from: self, cusHandler: nil)
		}
		
		
	}
	
	func fetchAttendees(completion:@escaping([Attendee]) -> ()) {
		var att = [Attendee]()
		ref = FIRDatabase.database().reference()
		do {
			handle = ref?.child("users").observe(.value, with: { (snapshot) in
				for i in snapshot.children {
					let v = (i as! FIRDataSnapshot).value as! [String:AnyObject]
					let nm = v["name"] as! String
					let bio = v["bio"] as? String
					let lin = v["link"] as? String
					let imgRef = v["image"] as? String
					var link:URL?
					if let l = lin {
						link = URL(string: l)
					}
					let a = Attendee(nm: nm, bi: bio, lnk: link, id: imgRef, img: nil)
					//					let a = Attendee(nm: nm, bi: bio, lnk: link, id:imgRef,)
					att.append(a)
				}
				completion(att)
			})
			
		} catch {
			Utility.displayAlertWithHandler("Error", message: "An error occurred, please try again", from: self, cusHandler: nil)
		}
	}
	
	
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
					vc.image = attendee.image
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

