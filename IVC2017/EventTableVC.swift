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
	var sessionsForView:[Session]?
	var satSessions:[Session]?
	var sunSessions:[Session]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
			FIRDatabase.database().persistenceEnabled = true
			
			if let d = Date().dayOfWeek() {
				self.fetchCalendarEvents(forDay: d, completion: { (sesh) in
					self.sessionsForView = sesh
					self.tableView.reloadData()
				})
			}
			
			
			var swtch = UISegmentedControl(items: ["Fri", "Sat", "Sun"])
			swtch.backgroundColor = UIColor.white
			swtch.tintColor = UIColor.cyan
			swtch.addTarget(self, action: #selector(switchDay(sender:)), for: .valueChanged)
			self.navigationItem.titleView = swtch
			
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		ref?.removeAllObservers()
		super.viewDidDisappear(animated)
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
	
	
	func fetchSpeakerFor(sesh:Session, completion:@escaping(Speaker) ->()) {
		
		
		
		
	}
	
	
	
//	func fetchSpeakers(forSession:Session, completion:@escaping([Speaker]) ->()) {
//	
//		var speakerArr:[Speaker] = []
//		ref = FIRDatabase.database().reference()
//		if forSession.speaker != "" && forSession.speaker != nil {
//			let sep = forSession.speaker!.components(separatedBy: ",")
////			let concurQueue = DispatchQueue(label: "com.queue.Concurrent", qos: .background, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
//			for i in sep {
////			concurQueue.async {
//				
//					self.handle = self.ref?.child("speakers").child(i).observe(.value, with: { (snapshot) in
//						let s = snapshot.value as! [String:AnyObject]
////						let s = snapshot.children
//						print("Print s: \(s)")
//						let dg = s["degrees"] as! String
//						let bio = s["bio"] as! String
//						let ln = s["link"] as! String
//						let lnk = URL(string: ln)
//						let f = Speaker(dgrs: dg, bi: bio, lnk: lnk, sesh: nil, nm: i)
//						speakerArr.append(f)
//						completion(speakerArr)
////						if speakerArr.count == sep.count {
////							completion(speakerArr)
////						}
//					})
////				}
////				if speakerArr.count == sep.count {
////					completion(speakerArr)
////				}
//			
////				if let sp = ref?.child("speakers").child(i) {
////				let s = sp as! [String:AnyObject]
////				let bio = s["bio"] as! String
//////				let degree = let degree = s["degrees"] as! String
//////				let spk = Speaker(dgrs: degree, bi: bio, lnk: lnk, sesh: nil, nm: i)
//////				speakerArr.append(spkr)
////				}
//			}
//		
//		}
//		
//		
//		
////		if forSession.speaker != "" && forSession.speaker != nil {
////			
////			print("Print sep: \(sep)")
////
////			for i in sep {
////			print("Print i: \(i)")
////				
////				print("Print speakerArr: \(speakerArr)")
////				}
////
////		}
//	}
	
	
		func fetchCalendarEvents(forDay:String, completion: @escaping([Session]) ->()) {
		
			var sesh:[Session] = []
			ref = FIRDatabase.database().reference()
			handle = ref?.child("schedule").child(forDay).observe(.value, with: { (snapshot) in
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
		}
	
	//				if let friSesh = snapshot.childSnapshot(forPath: "schedule").childSnapshot(forPath: "friday").value as? [String:AnyObject] {
	//					print("Print frisesh: \(friSesh)")
	//				}
	//			})
//	func updateDB(){
//		handle = ref?.child("schedule").observe(.childAdded, with: { (snapshot) in
//			if let snap = snapshot.value as? [String:AnyObject] {
//				print("Print snap: \(snap)")
//			}
//		})
//	}

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
			if sessionsForView != nil {
			if (sessionsForView?.count)! > 0 {
				if let contents = sessionsForView?[indexPath.row] {
//					var speakerLabelText = ""
//					for i in (contents.speaker)! {
//						speakerLabelText.append(i.name + i.degrees)
//					}
//					cell.speakerLabel.text = contents.speaker
					cell.timeLabel.text = contents.time
//					cell.locationLabel.text = contents.location
					cell.titleLabel.text = contents.title
				}
			 }
			}
			
        // Configure the cell...
        return cell
    }
	
	 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
//		if let sesh =  {
		if self.sessionsForView!.count > 0 {
			 let content = self.sessionsForView![indexPath.row] 
			
				self.transitionToSessioNVC(sesh: content)
			
//			let vc = self.tabBarController?.storyboard?.instantiateViewController(withIdentifier: "sessionvc") as! SessionVC
//					vc.address = content.addr
//					vc.time = content.time
//					vc.day = content.day
//					vc.location = content.location
//					vc.titl = content.title
//				  vc.desc = content.desc
			
//					var speakerArr:[Speaker] = []
			
//					if content.speaker != "" && content.speaker != nil {
//					
//						speakerArr = []
//						if let sep = content.speaker?.components(separatedBy: ",") {
//							for i in sep {
//							 self.fetchSpeaker(name: String(describing:i), completion: { (speaker) in
//									speakerArr.append(speaker)
////								vc.speakers = speakerArr
////								self.transitionToSessioNVC(vc:
////									vc)
//							})
//								
//							}
//						
//						}
//					} else {
////						vc.speakers = nil	
////						self.transitionToSessioNVC(vc: vc)
////						self.navigationController?.pushViewController(vc, animated: false)
//
//					}
			}
//		} else {
//			print("perfunctory placeholder")
//			Utility.displayAlertWithHandler("Error", message: "There was a problem loading your schedule, please try again", from: self, cusHandler: nil)
//		}
	}
	
	func transitionToSessioNVC(sesh:Session){
		let vc = self.tabBarController?.storyboard?.instantiateViewController(withIdentifier: "sessionvc") as! SessionVC
		vc.sesh = sesh
		vc.address = sesh.addr
		vc.time = sesh.time
		vc.day = sesh.day
		vc.location = sesh.location
		vc.titl = sesh.title
		vc.desc = sesh.desc
		vc.delegate = self
		vc.speakers = sesh.speaker?.components(separatedBy: ",")
//		self.fetchSpeakers(forSession: sesh) { (spkr) in
//			vc.speakers = spkr
			self.tabBarController?.present(vc, animated: false, completion: nil)
		}
		
//		if sesh.speaker != nil && sesh.speaker != nil {
//			if let sep = sesh.speaker?.components(separatedBy: ",") {
//				for i in sep {
//					self.fetchSpeaker(name: String(describing: i), completion: { (spkr) in
//						speakerArr.append(spkr)
//						
////						if speakerArr.count == sep.count {
////							vc.speakers = speakerArr
////							self.tabBarController?.present(vc, animated: false, completion: nil)
////						}
//					})
//					if speakerArr.count == sep.count {
//						vc.speakers = speakerArr
//						self.tabBarController?.present(vc, animated: false, completion: nil)
//					}
//				}
//			}
//		}
//		vc.speakers = speakerArr
//		self.tabBarController?.present(vc, animated: false, completion: nil)
	
	
	
	
	func transitionToSpeaker(speaker:Speaker, sesh:Session) {
//		let a = speaker[num]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol TransitionToSpeakerDelegate{
	func transitionToSpeaker(speaker:Speaker, sesh:Session)
}

protocol DismissSpeakerDelegate{
	func transitionToSessioNVC(sesh:Session)
}
