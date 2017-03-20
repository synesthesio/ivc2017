//
//  EventTableVCTableViewController.swift
//  IVC2017
//
//  Created by synesthesia on 2/25/17.
//  Copyright © 2017 com.ivc.FirebaseDatabase. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class EventTableVC: UITableViewController,TransitionToSpeakerDelegate, DismissSpeakerDelegate {
	var handle:FIRDatabaseHandle?
	var ref:FIRDatabaseReference?
	var storageRef:FIRStorageReference?
	var sessionsForView:[Session]?
//	var myGrp = DispatchGroup()
	var attendees:[Attendee]?
	var loadingVC:LoadingVC!
	var goingToLoading:Bool = false
	var loaded:Bool = false
	var swtch:UISegmentedControl!
    override func viewDidLoad() {
			super.viewDidLoad()
			self.tabBarController?.navigationController?.navigationBar.layer.backgroundColor = Utility.purpleClr.cgColor
			self.navigationController?.navigationBar.barTintColor = Utility.purpleClr
			self.navigationController?.navigationBar.isTranslucent = false
			self.view.backgroundColor = Utility.redClr
			
			self.swtch = UISegmentedControl(items: ["Fri", "Sat", "Sun"])
			
			self.swtch.layer.borderWidth = 0.5
			self.swtch.layer.borderColor = Utility.purpleClr.cgColor
			self.swtch.layer.cornerRadius = 15.0
			self.swtch.layer.masksToBounds = true
			self.swtch.setDividerImage(self.imageWithColor(color: .clear, segmentedControl: swtch), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
			self.swtch.setBackgroundImage(self.imageWithColor(color: .clear, segmentedControl: swtch), for: .normal, barMetrics: .default)
			self.swtch.setBackgroundImage(self.imageWithColor(color: Utility.redClr, segmentedControl: swtch), for: .selected, barMetrics: .default)
			self.swtch.backgroundColor = Utility.redClr
			self.swtch.layer.borderColor = Utility.yellowClr.cgColor
			self.swtch.setTitleTextAttributes([NSForegroundColorAttributeName:Utility.purpleClr], for: .normal)
			self.swtch.setTitleTextAttributes([NSForegroundColorAttributeName:Utility.yellowClr], for: .selected)
			for i in swtch.subviews {
				let upperBorder:CALayer = CALayer()
				upperBorder.backgroundColor = Utility.yellowClr.cgColor
				upperBorder.frame = CGRect(x: 0, y: i.frame.size.height-1, width: i.frame.size.width, height: 1.0)
				i.layer.addSublayer(upperBorder)
			}
			self.swtch.addTarget(self, action: #selector(switchDay(sender:)), for: .valueChanged)
			self.navigationItem.titleView = self.swtch
			
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}

	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if var d = Date().dayOfWeek() {
			if d != "friday" || d != "saturday" || d != "sunday" {
				d = "friday"
			}
			self.fetchCalendarEvents(forDay: d, completion: { (sesh) in
				self.sessionsForView = sesh
				self.tableView.reloadData()
			})
			switch d {
			case "friday":
				self.swtch.selectedSegmentIndex = 0
			case "saturday":
				self.swtch.selectedSegmentIndex = 1
			case "sunday":
				self.swtch.selectedSegmentIndex = 2
			default:
				self.swtch.selectedSegmentIndex = 0
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let h = self.handle {
			self.ref?.removeObserver(withHandle: h)
		} else {
			self.ref?.removeAllObservers()
		}
	}
	
	
	func switchDay(sender:UISegmentedControl){
	
		switch sender.selectedSegmentIndex {
			case 1:
			self.fetchCalendarEvents(forDay: "saturday", completion: { (sat) in
				self.sessionsForView = sat
				self.tableView.reloadData()
			})
			break
			case 2:
			self.fetchCalendarEvents(forDay: "sunday", completion: { (sun) in
				self.sessionsForView = sun
				self.tableView.reloadData()
			})
			break
			default:
				self.fetchCalendarEvents(forDay: "friday", completion: { (fri) in
					self.sessionsForView = fri
					self.tableView.reloadData()
				})
			break
		}
	}
	
		func fetchCalendarEvents(forDay:String, completion: @escaping([Session]) ->()) {
		
			var sesh:[Session] = []
			ref = FIRDatabase.database().reference()
			
			do {
				self.handle = ref?.child("schedule").child(forDay).observe(.value, with: { (snapshot) in
					for child in snapshot.children {
						print("Printchild: \(child)")
						let v = (child as! FIRDataSnapshot).value as! [String:AnyObject]
						let speakerString = v["speaker"] as! String
						let add = v["addr"] as! String
						let titl = v["title"] as! String
						let loc = v["location"] as! String
						guard let time = v["time"] as? String else {
							let time = v["time "] as? String
							return
						}
						var description = ""
						if let dsc = v["desc"] as? String {
							description = dsc
						}
						let k = (child as! FIRDataSnapshot).key
						print("Printv: \(v)")
						print("Printk: \(k)")
						let a = Session(d: forDay, tm: time, add: add, loc: loc, spkr: speakerString, titl: titl, mT: Int(k)!, dsc: description)
						//					let a = Session(d: forDay, tm: time, add: add, loc: loc, spkr: speakerString, titl: titl, mT: Double(k)!, d)
						sesh.append(a)
					}
					completion(sesh)
				})
				
			} catch {
				Utility.displayAlertWithHandler("Error", message: "An error occurred, please try again", from: self, cusHandler: nil)
			}
		}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
			var ct = 1
			if let count = self.sessionsForView?.count {
				if count > 0 {
				ct = count
				}
			}
			return ct
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionTVCell
//				cell.backgroundColor = 
			
			if sessionsForView != nil {
			if (sessionsForView?.count)! > 0 {
				if let contents = sessionsForView?[indexPath.row] {
					cell.timeLabel.textColor = UIColor.white
					cell.timeLabel.text = contents.time
					cell.backgroundColor = Utility.redClr
					cell.layer.borderWidth = 0.5
					cell.layer.borderColor = Utility.yellowClr.cgColor
//					cell.locationLabel.text = contents.location
					cell.titleLabel.textColor = UIColor.white
					cell.titleLabel.text = contents.title
				}
			 }
			}
        return cell
    }
	
	 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let sesh = self.sessionsForView {
			if sesh.count > 0 {
				let content = sesh[indexPath.row]
				self.transitionToSessioNVC(sesh: content)
			}
		}
	}
	
	func transitionToSessioNVC(sesh:Session){
		let vc = self.tabBarController?.storyboard?.instantiateViewController(withIdentifier: "sessionvc") as! SessionVC
		
		vc.sesh = sesh
		vc.titl = sesh.title

		if let loc = sesh.location {
			if loc != "" {
				vc.location = loc		
			}
			
		}
		
		
		if let d = sesh.desc {
			if d != "" {
				vc.desc = d
			}
		}
		vc.delegate = self
		if let spkr = sesh.speaker {
			if spkr != "" {
				vc.speakers = spkr.components(separatedBy: ",")
			}
		}
		
			self.tabBarController?.present(vc, animated: false, completion: nil)
		}
	
	
	func transitionToSpeaker(speaker:Speaker, sesh:Session) {
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "speakervc") as! SpeakerVC
		vc.session = sesh
		vc.delegate = self
		vc.bioText = speaker.bio
		vc.nameTitle = speaker.name
		vc.link = speaker.link
		vc.degrees = speaker.degrees
		vc.speaker = speaker
		self.tabBarController?.present(vc, animated: false, completion: nil)
	}
	
	func imageWithColor(color: UIColor, segmentedControl:UISegmentedControl) -> UIImage {
		
//		let rect = CGRect(0.0, 0.0, 1.0, segmentedControl.frame.size.height)
		let rect = CGRect(x: 0, y: 0, width: 1, height: segmentedControl.frame.size.height)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		context!.setFillColor(color.cgColor);
		context!.fill(rect);
		let image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image!
		
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}

protocol TransitionToSpeakerDelegate{
	func transitionToSpeaker(speaker:Speaker, sesh:Session)
}

protocol DismissSpeakerDelegate{
	func transitionToSessioNVC(sesh:Session)
}
