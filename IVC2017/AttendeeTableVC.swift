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
	var aImages:[UIImage]?
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	var attendees:[Attendee]?
	var storageRef:FIRStorageReference?
    override func viewDidLoad() {
        super.viewDidLoad()
				self.colV.dataSource = self
				self.colV.delegate = self
			
				self.title = "Attendees"
				self.view.backgroundColor = Utility.redClr
			
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.fetchAttendees(completion: { (att) in
			self.attendees = att
			self.fetchUserImages()
		})
	}
	
	func fetchUserImages(){
		if let at = self.attendees {
			for i in at {
				if let id = i.uID{
					self.getImageFromFIR(uID: id, completion: { (img) in
						self.aImages?.append(img)
					})
				}
			}
		}
	}
	
	
	func fetchAttendees(completion:@escaping([Attendee]) -> ()) {
		var att = [Attendee]()
		ref = FIRDatabase.database().reference()
		handle = ref?.child("users").observe(.value, with: { (snapshot) in
			for i in snapshot.children {
				let v = (i as! FIRDataSnapshot).value as! [String:AnyObject]
				let nm = v["name"] as! String
				let bio = v["bio"] as? String
				let link = v["link"] as? URL
				let imgRef = v["image"] as? String
				let a = Attendee(nm: nm, bi: bio, lnk: link, id:imgRef)
				att.append(a)
			}
			completion(att)
		})
	}
	
	func getImageFromFIR(uID:String?, completion:@escaping(UIImage)->()) {
		var image:UIImage?
		self.storageRef = FIRStorage.storage().reference()
		
		let ref = storageRef?.child("images/" + "\(uID!)")
		ref?.data(withMaxSize: 5 * 1024 * 1024, completion: { (data, err) in
			
			if let e = err {
				print("Print err: \(e)")
				Utility.displayAlertWithHandler("Error", message: "Error Downloading Images, Please Try Again Later", from: self, cusHandler: nil)
			}
			
			if let d = data {
				image = UIImage(data: d)
				completion(image!)
			}
		})
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
	
				if let att = attendees {
					let attendee = att[indexPath.row]
					let vc = self.storyboard?.instantiateViewController(withIdentifier: "attendeevc") as! AttendeeVC
					vc.interests = attendee.bio
					vc.nameForTitle = attendee.name
					vc.link = attendee.link
					vc.uID = attendee.uID
					self.tabBarController?.present(vc, animated: false, completion: nil)
				}
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "atcell", for: indexPath)
		if let at = self.attendees {
		let content = at[indexPath.row]
		
			let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
			imgV.clipsToBounds = true
			imgV.contentMode = .scaleAspectFill
		
		if let img = self.aImages?[indexPath.row] {
			imgV.image = img

		} else {
			imgV.image = UIImage(named: "user")
		}
			cell.contentView.addSubview(imgV)
		}
		return cell
	}


//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//				var ct = 1
//			if let att = attendees {
//				ct = att.count
//			}
//			return ct
//    }

	
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
//				cell.backgroundColor = Utility.redClr
//			
//				if let att = attendees {
//					let at = att[indexPath.row] as! Attendee
//					cell.textLabel?.textColor = UIColor.white
//					cell.textLabel?.text = at.name
//					cell.detailTextLabel?.text = at.bio
////					cell.imageView?.image = at.image
//				}
//			return cell
//    }

//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if let att = attendees {
//			let attendee = att[indexPath.row]
//			let vc = self.storyboard?.instantiateViewController(withIdentifier: "attendeevc") as! AttendeeVC
//			vc.interests = attendee.bio
//			vc.nameForTitle = attendee.name
//			vc.link = attendee.link
//			vc.uID = attendee.uID
//			self.tabBarController?.present(vc, animated: false, completion: nil)
//		}
//	}


}
